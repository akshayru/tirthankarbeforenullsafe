import 'package:tirthankar/core/const.dart';
import 'package:tirthankar/widgets/custom_button_widget.dart';
import 'package:tirthankar/widgets/custom_progress_widget.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  var _value;
  var isPlay;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this,duration: Duration(microseconds: 250));
    _value = 0.0;
    isPlay = true;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: Text(
          "Album Name",
          style: TextStyle(
              color: AppColors.styleColor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomButtonWidget(
                  size: 50,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.styleColor,
                  ),
                ),
                Text(
                  "Playing Now",
                  style: TextStyle(
                      color: AppColors.styleColor, fontWeight: FontWeight.bold),
                ),
                CustomButtonWidget(
                  size: 50,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.menu,
                    color: AppColors.styleColor,
                  ),
                )
              ],
            ),
          ),
          CustomButtonWidget(
            image: 'assets/logo.jpg',
            size: MediaQuery.of(context).size.width * .7,
            borderWidth: 5,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(),
                ),
              );
            },
          ),
          Text("Song Name",
            style: TextStyle(
              color: AppColors.styleColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 2,
            ),
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomProgressWidget(
              value: _value,
              labelStart: "1.21",
              labelend: "3.46",

            ),
          ),
          Expanded(child: SizedBox()),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomButtonWidget(
                    size: 50,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.skip_previous,
                      color: AppColors.styleColor,
                    ),
                    borderWidth: 5,
                  ),
                  CustomButtonWidget(
                    size: 50,
                    onTap: () {
                      setState(() {
                        if(_value > .1){
                          _value -= .1;
                        }                        
                      });
                    },
                    child: Icon(
                      Icons.fast_rewind,
                      color: AppColors.styleColor,
                    ),
                    borderWidth: 5,
                  ),
                  CustomButtonWidget(
                    size: 80,
                    onTap: () {
                      if (_controller.value==0) {
                        _controller.forward();
                        setState(() {
                          isPlay = false;
                        });
                      } else {
                        _controller.reverse();
                        setState(() {
                          isPlay = true;
                        }); 
                      }
                    },
                    child: AnimatedIcon(
                        icon: AnimatedIcons.pause_play,
                        progress: _controller,
                        color: isPlay ? Colors.white : AppColors.styleColor,                        
                      ),
                      borderWidth: 5,
                      isActive: isPlay,                   
                  ),
                  CustomButtonWidget(
                    size: 50,
                    onTap: () {
                      setState(() {
                        if(_value < .9){
                          _value += .1;
                        }
                      });
                    },
                    child: Icon(
                      Icons.fast_forward,
                      color: AppColors.styleColor,
                    ),
                    borderWidth: 5,
                  ),
                  CustomButtonWidget(
                    size: 50,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.skip_next,
                      color: AppColors.styleColor,
                    ),
                    borderWidth: 5,
                  )
              ],
            ),
          ),
          SizedBox(height: 25), //This will add bottom side 25 padding, so button will not be all the way to bottom
        ],
      ),
    );
  }
}
