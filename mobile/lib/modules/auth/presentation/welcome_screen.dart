import 'package:ayni_ruta/core/design/app_colors.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_buttons.dart';
import 'package:ayni_ruta/core/widgets/atoms/app_page_dots.dart';
import 'package:ayni_ruta/core/widgets/molecules/brand_mark.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageController = PageController();
  var _currentPage = 0;

  static const _slides = [
    _WelcomeSlide(
      icon: Icons.alt_route_rounded,
      title: 'Tu ruta, a tu ritmo',
      text: 'Encuentra opciones claras para moverte por La Paz y El Alto.',
    ),
    _WelcomeSlide(
      icon: Icons.groups_rounded,
      title: 'La ciudad se mueve contigo',
      text: 'Comparte información útil y gana puntos Ayni durante tus viajes.',
    ),
    _WelcomeSlide(
      icon: Icons.accessibility_new_rounded,
      title: 'Pensada para cada viaje',
      text:
          'Configura accesibilidad y elige si priorizas tiempo, costo o seguridad.',
    ),
  ];

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_isLastPage) {
      widget.onCreateAccount();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
    child: Column(
      children: [
        const BrandMark(),
        const SizedBox(height: 20),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) =>
                _WelcomeSlideView(slide: _slides[index]),
          ),
        ),
        AppPageDots(count: _slides.length, current: _currentPage),
        const SizedBox(height: 24),
        AppPrimaryButton(
          label: _isLastPage ? 'Crear mi cuenta' : 'Continuar',
          onPressed: _continue,
        ),
        const SizedBox(height: 12),
        if (_isLastPage)
          AppTextButton(
            label: 'Ya tengo una cuenta',
            onPressed: widget.onSignIn,
          )
        else
          Text(
            'Desliza para continuar',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
      ],
    ),
  );
}

class _WelcomeSlide {
  const _WelcomeSlide({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;
}

class _WelcomeSlideView extends StatelessWidget {
  const _WelcomeSlideView({required this.slide});

  final _WelcomeSlide slide;

  @override
  Widget build(BuildContext context) => Semantics(
    label: slide.title,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 168,
          height: 168,
          decoration: const BoxDecoration(
            color: AppColors.soft,
            shape: BoxShape.circle,
          ),
          child: Icon(slide.icon, color: AppColors.primary, size: 78),
        ),
        const SizedBox(height: 40),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 14),
        Text(
          slide.text,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );
}
