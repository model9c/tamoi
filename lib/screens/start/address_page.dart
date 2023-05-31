import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_record/constants/common_size.dart';
import 'package:tomato_record/data/AddressModel.dart';
import 'package:tomato_record/data/AddressModelGeo.dart';
import 'package:tomato_record/screens/start/address_service.dart';
import 'package:tomato_record/utils/logger.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;
  final List<AddressModelGeo> _addressModelGeoList = [];
  bool _isGettingLocation = false;

  @override
  void dispose() {
    // statefullwidget 일 경우 해당 state가 없어질 때 controller를 함께 dispose 해줘야 한다.
    _addressController.dispose(); // 메모리 누수 발생 위험.
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: common_padding, right: common_padding),
      // left and right padding 주기
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              _addressModelGeoList.clear();
              _addressModel = await AddressService().searchAddressByStr(text);
              setState(() {});
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.blue)),
                hintText: '도로명으로 검색',
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                )),
          ),
          SizedBox(height: common_padding),
          TextButton.icon(
            onPressed: () async {
              // final text = _addressController.text;
              // if (text.isNotEmpty) {
              //   AddressService().searchAddressByStr(text);
              // }
              _addressModel = null;
              _addressModelGeoList.clear();
              setState(() {
                _isGettingLocation = true;
              });
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }

              _locationData = await location.getLocation();

              // logger.d(_locationData);
              List<AddressModelGeo> addresses = await AddressService()
                  .findAddressByCoordinate(lon: _locationData.longitude!, lat: _locationData.latitude!);
              _addressModelGeoList.addAll(addresses);

              setState(() {
                _isGettingLocation = false;
              });
            },
            icon: _isGettingLocation
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Icon(
                    CupertinoIcons.compass,
                    color: Colors.white,
                    size: 20,
                  ),
            label: Text(
              _isGettingLocation ? '위치 찾는 중...' : '현재위치로 찾기',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          if (_addressModel != null)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: common_padding),
                itemBuilder: (context, index) {
                  // logger.d('index : $index');
                  if (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null ||
                      _addressModel!.result!.items![index].address == null) {
                    return Container();
                  } else {
                    return ListTile(
                      // leading: Icon(Icons.image),
                      // trailing: ExtendedImage.asset('assets/img/tamoi.png'),

                      title: Text(_addressModel!.result!.items![index].address!.road ?? ""),
                      subtitle: Text(_addressModel!.result!.items![index].address!.parcel ?? ""),
                      onTap: () {
                        _saveAddressAndGoToNextPage(_addressModel!.result!.items![index].address!.road ?? "",
                            _addressModel!.result!.items![index].address!.zipcode ?? "");
                      },
                    );
                  }
                },
                itemCount:
                    (_addressModel == null || _addressModel!.result == null || _addressModel!.result!.items == null)
                        ? 0
                        : _addressModel!.result!.items!.length,
              ),
            ),
          if (_addressModelGeoList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: common_padding),
                itemBuilder: (context, index) {
                  // logger.d('index : $index');
                  // logger.d(_addressModelGeoList[index].result![0].text);
                  if (_addressModelGeoList[index].result == null || _addressModelGeoList[index].result!.isEmpty) {
                    return Container();
                  } else {
                    logger.d(_addressModelGeoList[index].result![0].text);
                    logger.d(_addressModelGeoList[index].result![0].zipcode);
                    return ListTile(
                      // leading: Icon(Icons.image),
                      // trailing: ExtendedImage.asset('assets/img/tamoi.png'),
                      title: Text(_addressModelGeoList[index].result![0].text ?? ""),
                      subtitle: Text(_addressModelGeoList[index].result![0].zipcode ?? ""),
                      onTap: () {
                        _saveAddressAndGoToNextPage(_addressModelGeoList[index].result![0].text ?? "",
                            _addressModelGeoList[index].result![0].zipcode ?? "");
                      },
                    );
                  }
                },
                itemCount: _addressModelGeoList.length,
              ),
            ),
        ],
      ),
    );
  }

  _saveAddressAndGoToNextPage(String address, String zipcode) async {
    await _saveAddressOnSharedPreference(address, zipcode);
    context.read<PageController>().animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  _saveAddressOnSharedPreference(String address, String zipcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', address);
    await prefs.setString('zipcode', zipcode);
  }

}

