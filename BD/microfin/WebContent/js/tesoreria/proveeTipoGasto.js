$(document).ready(function() {
	esTab = true;

	var catTipoConsultaSucursal = {
			'listaCombo':2
	};

	var catTipoConsultaTipoGasto={
			'principal':1

	};
	var catTipoListaProveedores={
			'sucursales':2
	};

	var catTipoTransaccionPov={
			'principal':1,
			'provAGastos':4

	};

	$(':text').focus(function() {		
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){

			esTab= true;	
		}
	});




	$('#tipoGastoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcionTG";
			parametrosLista[0] = $('#tipoGastoID').val();

			lista('tipoGastoID', '2', 1, camposLista, parametrosLista, 'requisicionTipoGastoListaVista.htm');
		}
	});

	$('#tipoGastoID').blur(function(){
		var tipoPago = $('#tipoPago').val();	
		if(tipoPago!='N'){
			if(tipoPago=='S'){
				var tipoDescrip = eval("'#descripcionTG'");
				consultaTipoGasto(this.id,tipoDescrip);		  	
				limpiaSucursales();
				
				habilitaBoton('agregaProv', 'submit'); 
			}else{
				alert('El proveedor tiene otra forma de pago que no es Spei');
				deshabilitaBoton('agregaProv', 'submit'); 
			}
		}	
	});


	$('#proveedorID').blur(function(){
		limpiaSucursales();

	});


	$('#agregaProv').click(function(event) {	
		$('#tipoTransaccion').val(catTipoTransaccionPov.provAGastos);	
	});	



	function consultaSucursales() {

		var sucursalBean = {
				'sucursalID' : 0,
		};
		sucursalesServicio.listaCombo(catTipoConsultaSucursal.listaCombo,sucursalBean,function(data) { 
			if(data!=null){
				var ul = '<div id="listaSucursalesDiv"> <ul>';
				for(var i=0; i<data.length; i++){
					ul += '<li value="'+data[i].sucursalID+'">';
					ul += '<input type="checkbox" id="'+data[i].sucursalID+'"  name="ListaSucursales" value="0" onclick="validaChek('+data[i].sucursalID+')" />';
					ul += '<input type="text" id="suc'+data[i].sucursalID+'"  value="'+data[i].nombreSucurs+'" disabled="true" />';

					ul +='</li>';
				}
				ul += '</ul> </div>';

				$('#listaSucursalesDiv').replaceWith(ul);

				consultaSucurDeProv();
			}
			else{
				alert("No existe la sucursal.");
				$('#numReqGasID').val(0);
				validaRequisicion('numReqGasID');
				$('#sucursalID').val('');
				$('#nombreSucurs').val('');
			}
		});

	}

	function consultaTipoGasto(idControl,tipoDescrip){
		var jqTipoGasto = eval("'#" + idControl + "'");
		var numTipoGasto = $(jqTipoGasto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoGasto != '' && !isNaN(numTipoGasto) ){

			var RequisicionTipoGastoListaBean = {
					'tipoGastoID' : numTipoGasto
			};

			requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal,RequisicionTipoGastoListaBean,function(tipoGastoCon){

				if(tipoGastoCon!=null){

					$(tipoDescrip).val(tipoGastoCon.descripcionTG);
					consultaSucursales();
				}else{
					alert("No existe el Tipo de Gasto");
					$(jqTipoGasto).focus();

				}

			});				
		}
	}

	function consultaSucurDeProv(){

		if($('#proveedorID').val() != '' && $('#tipoGastoID').val() != '' && !isNaN($('#proveedorID').val())  && !isNaN($('#tipoGastoID').val()) ){
			var proveedorBeanCon = { 
					'proveedorID':$('#proveedorID').val(),
					'tipoGastoID':$('#tipoGastoID').val()
			};
			var sucursalID;
			proveedoresServicio.lista(catTipoListaProveedores.sucursales,proveedorBeanCon,function(proveedores) {
				if(proveedores!=null){

					for(var i=0; i< proveedores.length; i++){

						sucursalID = proveedores[i].sucursal;
						jqSucurID = eval("'#" + sucursalID + "'");
						$(jqSucurID).attr('checked','true');
						$(jqSucurID).val(sucursalID);
					}

				}
			});
		}

	}


	function limpiaSucursales(){
		var sucs = '<div id="listaSucursalesDiv"> </div>';	
		$('#listaSucursalesDiv').html(sucs);

	}

});//fin jQuery


function validaChek(numero){

	var opcionMenuChkDer = eval("'#" + numero + "'");

	if ($(opcionMenuChkDer).is(":checked")) {
		$(opcionMenuChkDer).val(numero);
	}	
	else
	{
		$(opcionMenuChkDer).val(0);
	}

}
