import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/constants/app_colors.dart';
import 'package:fluxfoot_user/features/filter/view_model/bloc/filter_bloc.dart';
import 'package:fluxfoot_user/features/home/views/widgets/perticularbrand_tabar_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({
    super.key,
    required this.width,
    required this.height,
    FilterBloc? bloc,
  }) : _bloc = bloc,
       _textController = TextEditingController();

  final double width;
  final double height;

  final FilterBloc? _bloc;
  final TextEditingController _textController;

  FilterBloc _resolveBloc(BuildContext context) =>
      _bloc ?? context.read<FilterBloc>();

  @override
  Widget build(BuildContext context) {
    final bloc = _resolveBloc(context);
    return Stack(
      children: [
        LiquidGlassLayer(
          settings: iosGlassSettings,
          child: Row(
            spacing: width * 0.03,
            children: [
              // Main Search Bar with Interactive Glow
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 15),
                child: GlassGlow(
                  glowColor: Colors.white24,
                  glowRadius: 1.0,
                  child: Container(
                    width: width * 0.79,
                    height: height * 0.099,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: BlocListener<FilterBloc, FilterState>(
                            bloc: bloc,
                            listenWhen: (prev, curr) =>
                                prev.searchQuery != curr.searchQuery,
                            listener: (_, state) {
                              _textController.value = _textController.value
                                  .copyWith(
                                    text: state.searchQuery,
                                    selection: TextSelection.collapsed(
                                      offset: state.searchQuery.length,
                                    ),
                                  );
                            },
                            child: TextField(
                              controller: _textController,
                              style: GoogleFonts.openSans(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                              onChanged: (value) {
                                context.read<FilterBloc>().add(
                                  UpdateSearchQuery(value),
                                );
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search...',
                                hintStyle: GoogleFonts.openSans(
                                  color: Colors.black45,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //! Voice To Speech Button with Interactive Glow
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 15),
                child: GlassGlow(
                  glowColor: Colors.white24,
                  glowRadius: 1.0,
                  child: BlocBuilder<FilterBloc, FilterState>(
                    bloc: bloc,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          if (state.isListeningForSpeech) {
                            context.read<FilterBloc>().add(
                              StopListening(state.searchQuery),
                            );
                          } else {
                            context.read<FilterBloc>().add(StartListening());
                          }
                        },
                        child: SizedBox(
                          width: width * 0.099,
                          height: height * 0.099,
                          child: Icon(
                            state.isListeningForSpeech
                                ? CupertinoIcons.mic_fill
                                : CupertinoIcons.mic_off,
                            color: AppColors.iconBlack,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
