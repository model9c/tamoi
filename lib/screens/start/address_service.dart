import 'package:dio/dio.dart';
import 'package:tomato_record/constants/keys.dart';
import 'package:tomato_record/data/AddressModel.dart';
import 'package:tomato_record/data/AddressModelGeo.dart';
import 'package:tomato_record/utils/logger.dart';

class AddressService {
  void dioTest() async {
    var response =
        await Dio().get('https://randomuser.me/api/').catchError((e) {
      logger.e(e);
    });
    logger.d(response);
  }

  Future<AddressModel> searchAddressByStr(String text) async {
    // 요청URL ADR : http://api.vworld.kr/req/search?key=인증키&[검색API 요청파라미터]
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'size': 30,
      'query': text,
      'type': 'ADDRESS',
      'category': 'ROAD',
    };
    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      logger.e(e);
    });

    // logger.d(response);   //Json 데이터가 MAP형식으로 인식이 됨.
    // logger.d(response.data["response"]["result"]);

    AddressModel addressModel =
        AddressModel.fromJson(response.data["response"]);
    // logger.d(addressModel);

    return addressModel;
  }

  Future<List<AddressModelGeo>> findAddressByCoordinate(
      {required double lon, required double lat}) async {
    // http://api.vworld.kr/req/address?service=address&request=getCoord&key=인증키&[요청파라미터]
    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>>[];
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$lon,$lat',
    });

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${lon - 0.01},$lat',
    });

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${lon + 0.01},$lat',
    });

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$lon,${lat - 0.01}',
    });

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$lon,${lat + 0.01}',
    });

    List<AddressModelGeo> addresses = [];

    for (Map<String, dynamic> formData in formDatas) {
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        logger.e(e);
      });
      // logger.d(response.data['response']);
      AddressModelGeo addressModelGeo =
          AddressModelGeo.fromJson(response.data['response']);

      if (response.data['response']['status'] == 'OK') {
        addresses.add(addressModelGeo);
      }
    }

    logger.d(addresses);
    return addresses;
    // return
  }
}
