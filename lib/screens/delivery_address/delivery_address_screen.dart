import 'package:ecommerce_app/blocs/profile/bloc.dart';
import 'package:ecommerce_app/constants/image_constant.dart';
import 'package:ecommerce_app/data/models/models.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:ecommerce_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delivery_address_bottom_sheet.dart';
import 'delivery_address_card.dart';

class DeliveryAddressModelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context)!.translate("delivery_address")),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Loading();
            }
            if (state is ProfileLoaded) {
              var addressList = state.loggedUser.addresses;
              return addressList.isNotEmpty
                  ? _buildContent(addressList)
                  : _buildNoAddress(context);
            }
            if (state is ProfileLoadFailure) {
              return Center(child: Text("Load Failure"));
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDeliveryBottomSheet(context),
        label: Text(
          Translate.of(context)!.translate("add_new_address"),
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontSize: 18,
            color: Colors.white
          ),
        ),
        icon: Icon(Icons.add,  color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _buildContent(List<DeliveryAddressModel> addressList) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: addressList.length,
      itemBuilder: (context, index) {
        return DeliveryAddressCard(
          deliveryAddress: addressList[index],
          onPressed: () => _openDeliveryBottomSheet(
            context,
            deliveryAddress: addressList[index],
          ),
        );
      },
    );
  }

  _buildNoAddress(BuildContext context) {
    return Center(
      child: Image.asset(IMAGE_CONST.ADD_ADDRESS),
    );
  }

  _openDeliveryBottomSheet(BuildContext context,
      {DeliveryAddressModel? deliveryAddress}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DeliveryAddressModelBottomSheet(
            deliveryAddress: deliveryAddress);
      },
    );
  }
}
