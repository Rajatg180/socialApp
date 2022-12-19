import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation({
    required this.child,
    required this.isAnimating,
    this.duration=const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike=false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ~/2 is used to divide milli second into 2 and convert it into int
    controller=AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/2,
      ),
    );
    scale=Tween<double>(begin: 1,end: 1.2).animate(controller);
  }
  
  @override
  void didUpdateWidget (covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating!=oldWidget.isAnimating){
      startAnimation();
    }
    
  }

  startAnimation() async{
    if(widget.isAnimating || widget.smallLike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 120,),);

      if(widget.onEnd!=null){
        widget.onEnd!();
      }
    }
  }
  
  @override 
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}