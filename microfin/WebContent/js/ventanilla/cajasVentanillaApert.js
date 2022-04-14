var catTipoTransCajas= {
	'apert' : 9
};

var catTipoListaCajasVentanilla = {
	'cajaComboCA': 3,
	'cajaComboCP': 4
};
$(document).ready(function (){
	esTab = true;

	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#cajaID').focus();
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true', 'apert', 'inicializaParametros','donothign');
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
		if(Number(sucursal)<=0 || sucursal == null || sucursal == undefined){return;}
		var jqCaja = eval("'#"+idCaja+"'");
		
		 var CajasVentanillaBeanConCajSuc = {
		  			'cajaID': $('#cajaIDSesion').val()
				};
		 var conPrincipal = 3;
				
					cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
						if(cajasVentanillaConCaja != null)
						{
							if(cajasVentanillaConCaja.sucursalID != sucursal){
								mensajeSis('No puede realizar esta operación ya que la sucursal del cajero no concuerda con la sucursal asignada a la caja.');
								$(jqCaja).attr('disabled','true');
								deshabilitaBoton('apert','submit');
								
							}else{

								var consultaCajaEO = 7;
								var parametrosBeanVentanilla = {
										'sucursalID':sucursal,
										'cajaID':$('#cajaIDSesion').val()
								};
								//estan es para consultar la propia caja si esta cerrada no importa si es BG pues nunca esta cerrada
								cajasVentanillaServicio.consulta(consultaCajaEO, parametrosBeanVentanilla , function(cajaVentanilla){
									if(cajaVentanilla != null)
									{
										if(cajaVentanilla.estatusOpera == 'C'){
											mensajeSis('La caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
											$(jqCaja).attr('disabled','true');
											deshabilitaBoton('apert','submit');
											
										}else{
									
											var tipoConsulta = 3;
											var bean = {
													'estatusOpera': eOpera,
													'cajaID': caja,
													'tipoCaja':tipoCaja,
													'sucursalID':sucursal
												};
											dwr.util.removeAllOptions(idCaja);
											if(tipoCaja == 'CA'){
												mensajeSis('La Cajas de Atención al Público No pueden Aperturar otras Cajas de Atención al Público.');
												$(jqCaja).attr('disabled','true');
												deshabilitaBoton('apert','submit');
												
											}else{
												cajasVentanillaServicio.listaCombo(tipoConsulta, bean , function(cajaVentanilla){
													if(cajaVentanilla!=null)
													{
														if(cajaVentanilla.length <=0){mensajeSis('No existen más Cajas de Atención al Público para Aperturar');
														$(jqCaja).attr('disabled','true');
														deshabilitaBoton('apert','submit');
														}
														else{
															dwr.util.addOptions(idCaja, cajaVentanilla, idCaja, 'descripcionCaja');
															habilitaBoton('apert','submit');
															if(tipoCaja != 'CA')
															{$(jqCaja).removeAttr('disabled');}
														}
														
													}
													else{
													mensajeSis('No existen más Cajas de Atención al Público para Aperturar');
													$(jqCaja).attr('disabled','true');
													deshabilitaBoton('apert','submit');
													}
												});
											}
											
										}	
									}
								});
							
							}
						}
					});
		 
	 }
	function inicializaParametros(){
		deshabilitaBoton('apert','submit');
		var parametroBean = consultaParametrosSession();
		$('#fecha').val(parametroBean.fechaSucursal);
		$('#tipoTransaccion').val(9);
		if (parametroBean.tipoCaja == '' || parametroBean.tipoCaja == undefined){
			mensajeSis('El Usuario no tiene una Caja asignada.');
			$('#sucursalID').attr('disabled','true');
			$('#cajaID').attr('disabled','true');
			$('#fecha').attr('disabled','true');
		}else{
			$('#sucursalID').val($('#sucursalIDSesion').val());
			$('#dessucursal').val(parametroBean.nombreSucursal);
			cargaCajasVentanillaCombo('cajaID',0,$('#sucursalIDSesion').val(),parametroBean.tipoCaja,'C');
			}
		
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
	function donothign(){

	}