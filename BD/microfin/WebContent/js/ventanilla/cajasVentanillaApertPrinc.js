var catTipoTransCajas= {
	'apert' : 9
};
$(document).ready(function (){
	esTab = true;



	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#cajaID').focus();
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
	      submitHandler: function(event) { 
	      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true', 'apert','deshabilitaItems','donothign');
	      	
	      }
	});

	$('#formaGenerica').validate({	
		rules: {
			cajaID: {
				required: true
			}
		},		
		messages: {
			cajaID: {
				required: ''
			}
			
		}		
	});

	

}); // Fin Jquery

	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
		var key = nav4 ? evt.which : evt.keyCode;
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46);
	}
	function cargaCajasVentanillaCombo(idCaja,caja,sucursal,tipoCaja,eOpera){
		var jqCaja = eval("'#"+idCaja+"'");
		var tipoConsulta = 3;
		var bean = {
				'estatusOpera': eOpera,
				'cajaID': caja,
				'tipoCaja':tipoCaja,
				'sucursalID':sucursal
			};
		dwr.util.removeAllOptions(idCaja);
		cajasVentanillaServicio.listaCombo(tipoConsulta, bean , function(cajaVentanilla){
			if(cajaVentanilla!=null)
			{
				if(cajaVentanilla.length==1){
					dwr.util.addOptions(idCaja, cajaVentanilla, idCaja, 'descripcionCaja');
					habilitaBoton('apert','submit');
					if($(jqCaja).val()==null){
						deshabilitaItems();
					}
					else{
						if(tipoCaja != 'CA')
						{habilitaItems();}
						}
				}else if (cajaVentanilla.length>1){
					mensajeSis('Solo Puede existir una Caja Principal por Sucursal. Favor de dar de Baja para poder seguir Operando.');
					deshabilitaItems();
				}	else{
					mensajeSis('La caja Principal ya se encuentra Aperturada.');
					deshabilitaItems();
				
				}
				
			}
			else{
				mensajeSis('La caja Principal no esta disponible. verifique su estado.');
				deshabilitaItems();
			}
		});
	}
	
	function inicializaParametros(){
		deshabilitaBoton('apert','submit');
		var parametroBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);

		$('#tipoTransaccion').val(catTipoTransCajas.apert);
		$('#sucursalID').val($('#sucursalIDSesion').val());
		$('#dessucursal').val(parametroBean.nombreSucursal);
		cargaCajasVentanillaCombo('cajaID','0',$('#sucursalIDSesion').val(),'GE','');//GE de gerente
	}

	function consultaSucursaldeCaja(numCajaID){
		if(Number(numCajaID)<=0){return;}
		 var CajasVentanillaBeanCon = {
		  			'cajaID': numCajaID
				};
		 var conPrincipal = 3;
				
				if(numCajaID != '' && !isNaN(numCajaID)){
					cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanCon ,function(cajasVentanilla){
						if(cajasVentanilla.sucursalID != null)
						{
							$('#sucursalID').val(cajasVentanilla.sucursalID);
							var conforSuc = 2;
							sucursalesServicio.consultaSucursal(conforSuc, cajasVentanilla.sucursalID ,function(sucursalCaja){
								if(sucursalCaja.nombreSucurs != null)
								{
									$('#dessucursal').val(sucursalCaja.nombreSucurs);
								}
								
							});
						}
						
					});
					}
	 }

function deshabilitaItems(){
	dwr.util.removeAllOptions('cajaID');
  	$('#cajaID').attr('disabled','true');
	deshabilitaBoton('apert','submit');
}
function habilitaItems(){
	$('#cajaID').removeAttr('disabled');
	habilitaBoton('apert','submit');
}
function donothign(){
	//se completo esta funcion para completar la funcion grabaFormaTransaccionRetrollamada en la funcion de frecasodetransaccion
}
