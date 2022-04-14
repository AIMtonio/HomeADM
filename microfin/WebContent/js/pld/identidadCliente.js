$(document).ready(function (){
	
	esTab=true;
	agregaFormatoControles('formaGenerica');
	var parametroBean = consultaParametrosSession();
	$('#clienteID').focus();
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	var Enum_Tra={
		'agrega' :1,
		'modifica':2
	};
		
	$.validator.setDefaults({
        submitHandler: function(event) {       
        	procede = validaActEmpresarial(event);
        	if(procede == 'S'){
    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','clienteID', 'exito');

        	}
            
        }
  	});
	
	
	 $('#formaGenerica').validate({
		 rules: {
			 clienteID: {
				 required: true,			
			 },
			 fuenteOtraDet:{
				 required: function(){return $('#fuenteOtra').is(':checked');}
			 },
			 ingresoAdici:{
				 required: function(){return ($('#fuenteOtra').is(':checked') 
						 					|| ($('#tipoOtroNuevo').is(':checked') && $('#fuenteComer').is(':checked')));}
			 },									
			 tipoOtroNegocio: {
				 required: function(){return $('#tipoOtro').is(':checked');}
			 },
			 giroNegocio:{
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');}
			 },
			 aniosAntig: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
				 number: true,
				 maxlength:4
			 },
			 mesesAntig: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
			 	number: true,
			 	maxlength:4
			 },
			 ubicacNegocio: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');}
			 },
			 tipoProducto: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');}
			 },
			 mercadoDeProducto: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
			 	maxlength: 200
			 },
			 ingresosMensuales: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
				 maxlength:18,
				 number:true
			 },
			 dependientesEcon: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked') ;},
			 	 number:	true,
			 	 maxlength:4
			 },
			 dependienteHijo: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
			 	 number: true,
			 	 maxlength:4
			 },
			 dependienteOtro: {
				 required: function(){return $('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked');},
				 number: true,
				 maxlength:4
			 },
			 especificarNegocio:{
				 required: function(){return ($('#esNegocioPropioNO').is(':checked') && $('#incrementoVentas').is(':checked'));}
			 },
			 tipoOtroNuevoNegocio:{
				 required: function(){return ($('#tipoOtroNuev').is(':checked') && $('#negocioNuevoTipo').is(':checked'));},
				 maxlength:100
			 },
			 tipoProdTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked') && $('#fuenteComer').is(':checked'));},
				 maxlength:500
			 },
			 mercadoDeProdTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked') && $('#fuenteComer').is(':checked'));},
				 maxlength:200
			 },
			 ingresosMensTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked') && $('#fuenteComer').is(':checked'));},
				 number: true,
				 maxlength:18
			 },
			 dependientesEconTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked')  && $('#fuenteComer').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 dependienteHijoTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked')  && $('#fuenteComer').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 dependienteOtroTipoNeg:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked')  && $('#fuenteComer').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 tiempoNuevoNeg: {
				 required: function(){return ($('#tipoFamiliarExt').is(':checked'));}
			 },
			 tiempoEnvio: {
				 required: function(){return ($('#tipoFamiliarExt').is(':checked'));},
				 maxlength:50
			 },
			 cuantoEnvio: {
				 required: function(){return ($('#tipoFamiliarExt').is(':checked'));},
				 maxlength:18,
				 number: true
			 },
			 parentesOtroDet: {
				 required: function(){return ($('#parentescoOtro').is(':checked') && $('#tipoFamiliarExt').is(':checked'));}
			 },
			 trabajoActual: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));}
			 },
			 lugarTrabajoAct: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));}
			 },
			 cargoTrabajo: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));}
			 },
			 periodoDePago: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));}
			 },
			 montoPeriodoPago: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));},
				 maxlength:18,
				 number:true
			 },
			 tiempoLaborado: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));},
				 maxlength:100
			 },
			 dependientesEconSA: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 dependienteHijoSA: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 dependienteOtroSA: {
				 required: function(){return ($('#tipoCambioTrab').is(':checked'));},
				 number: true,
				 maxlength:4
			 },
			 cargoPubPEPDet: {
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
						 					|| $('#cargoPubPEPSO').is(':checked'));}
			 },
			 nivelCargoPEP:{
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
	 					|| $('#cargoPubPEPSO').is(':checked'));}				 
			 },
			 periodo1PEP: {
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
		 									|| $('#cargoPubPEPSO').is(':checked'));},
		 		maxlength:50	
			 },
			 periodo2PEP: {
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
		 									|| $('#cargoPubPEPSO').is(':checked')); },
		 		maxlength:50
			 },
			 ingresosMenPEP: {
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
							|| $('#cargoPubPEPSO').is(':checked') );},
							number: true
			 },
			 famEnCargoPEP: {
				 required: function(){return ($('#cargoPubPEPSi').is(':checked') 
							|| $('#cargoPubPEPSO').is(':checked') );}							
			 },
			 nombreCompletoPEP: {
				 required: function(){return (($('#cargoPubPEPSi').is(':checked') 
											|| $('#cargoPubPEPSO').is(':checked')) && $('#famEnCargoPEPSi').is('checked'));},
				maxlength:100
			 },
			 nombreRelacionPEP: {
				 required: function(){return ($('#cargoPubPEPFa').is(':checked') && $('#relacionPEPSi').is(':checked')); }
			 },
			 parentescoPEPDet: {
				 required: function(){return ($('#cargoPubPEPFa').is(':checked') && $('#parentescoPEPOtr').is(':checked'));}
			 },
			 fuenteIngreOS: {
				 required: function(){return ($('#ingresoAdiciSi').is(':checked') && $('#fuenteOtra').is(':checked') 
						 						|| ($('#ingresoAdiciSi').is(':checked') && $('#tipoOtroNuevo').is(':checked') && $('#fuenteComer').is(':checked')));}	
			 									 
			 },
			 UbicFteIngreOS: {
				 required: function(){return ($('#ingresoAdiciSi').is(':checked') && $('#fuenteOtra').is(':checked')
						 						|| ($('#ingresoAdiciSi').is(':checked') && $('#tipoOtroNuevo').is(':checked') && $('#fuenteComer').is(':checked')));}
			 },
			 ingMensualesOS: {
				 required: function(){return ($('#ingresoAdiciSi').is(':checked') && $('#fuenteOtra').is(':checked')
						 || ($('#ingresoAdiciSi').is(':checked') && $('#tipoOtroNuevo').is(':checked') && $('#fuenteComer').is(':checked')));},
				 
				 maxlength:18,
				 number:true
			 
			 },
			 esPropioFteDet: {
				 required: function(){return ($('#ingresoAdiciSi').is(':checked') && $('#esPropioFteIngNo').is(':checked'));}
			 },
			 cargoPubPEPDetFam: {
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 periodo1PEPFam: {
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 periodo2PEPFam: {
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 nombreCtoPEPFam:{
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 nivelCargoPEPFam:{
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 parentescoPEPFam:{
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 relacionPEP:{
				 required: function(){return ($('#cargoPubPEPFa').is(':checked'));}
			 },
			 propietarioNombreCom:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioDomici:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioNacio:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioCurp:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioRfc:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioFecha:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioGener:{
				 required: function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioLugarNac:{
				 required: 	function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioEntid:{
				 required: 	function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 propietarioPais:{
				 required: 	function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 tipoProvRecursos:{
				 required: 	function(){return ($('#fuenteNuevaAct').is(':checked')
	 										|| $('#fuenteProvRecur').is(':checked'));}
			 },
			 nombreCompProv:{
				 required: 	function(){return ($('#proveedPFisica').is(':checked'));}
			 },
			 domicilioProv:{
				 required:	function(){return ($('#proveedPFisica').is(':checked'));}
			 },
			 fechaNacProv:{
				 required:	function(){return ($('#proveedPFisica').is(':checked'));}
			 },
			 nacionalidProv:{
				 required:	function(){return ($('#proveedPFisica').is(':checked'));}
			 },
			 rfcProv:{
				 required:	function(){return ($('#proveedPFisica').is(':checked'));}
			 },
			 razonSocialProvB:{
				 required:	function(){return ($('#proveedPMoral').is(':checked'));}
			 },
			 nacionalidProvB:{
				 required:	function(){return ($('#proveedPMoral').is(':checked'));}
			 },
			 rfcProvB:{
				 required:	function(){return ($('#proveedPMoral').is(':checked'));}
			 },
			 domicilioProvB:{
				 required:	function(){return ($('#proveedPMoral').is(':checked'));}
			 },
			 propietarioOcupac:{
				 required: 	function(){return ($('#fuenteComer').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteNuevaAct').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| $('#fuenteProvRecur').is(':checked') && ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked'))
	 						|| ($('#propietarioFam').is(':checked') || $('#propietarioOtro').is(':checked')));}
			 },
			 observacionesEjec: {
				 required: true
			 },
			 parentescoPEP:{
				 required: function(){return ($('#famEnCargoPEPSi').is(':checked'));}
			 },
			 otroAplDetalle:{
				 required: function(){return ($('#otroAplCuest').is(':checked'));}
			 },
			 cargoPubPEP:{
				 required: function(){return ($('#fuenteComer').is(':checked') 
						 				   || $('#fuenteNuevaAct').is(':checked')
						 				   || $('#fuenteProvRecur').is(':checked'));}
			 },	
			 tipoNegocio:{
				 required: function(){return ($('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked'));}
			 },
			 esPropioFteIng:{
				 required:  function(){return ($('#ingresoAdiciSi').is(':checked') && $('#fuenteOtra').is(':checked')
						 || ($('#ingresoAdiciSi').is(':checked') && $('#tipoOtroNuevo').is(':checked') && $('#fuenteComer').is(':checked')));}, 
					
			 },
			 esNegocioPropio:{
				 required: function(){return ($('#incrementoVentas').is(':checked') && $('#fuenteComer').is(':checked'));}
			 },
			 tipoNuevoNegocio:{
				 required: function(){return ($('#negocioNuevoTipo').is(':checked') && $('#fuenteComer').is(':checked'));}
			 },
			 parentescoApert:{
				 required: function(){return ($('#tipoFamiliarExt').is(':checked') && $('#fuenteComer').is(':checked'));}
			 },			 
			 fuenteRecursos:{
				 required: function(){return ($('#realizadoOpSI').is(':checked'));}
			 },
						 
		 },			 
		 messages: {		
			 clienteID: {
				 required:'Especifique el Cliente.'				
			 },
			 fuenteOtraDet:{
				 required: 'Especifique su Fuente de Recursos.'
			 },
			 ingresoAdici:{
				 required: 'Especifique Ingreso Adicional.'
			 },
			 tipoOtroNegocio: {
				 required: 'Especifique el Tipo de Negocio.'
			 },
			 giroNegocio:{
				 required: 'Especifique el Giro del Negocio.'
			 },
			 aniosAntig:{
				 required: 'Especifique Años del Negocio.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Carácteres'
			 },
			 mesesAntig:{
				 required: 'Especifique Meses del Negocio.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Carácteres.'
			 },
			 ubicacNegocio:{
				 required: 'Especifique Ubicación.'
			 },
			 tipoProducto:{
				 required: 'Especifique Tipo de Producto.'
			 },
			 mercadoDeProducto:{
				 required: 'Especifique (Persona/Empresa).',
				 maxlength:'Máximo 200 Caracteres.'
			 },
			 ingresosMensuales:{
				 required: 'Especifique Ingresos Mensuales.',
				 number: 	'Solo Números.',
				 maxlength:'Máximo 18 Caracteres.'
			 },
			 dependientesEcon:{
				 required: 'Especifique Dependientes.',
				 number: 	'Solo Números',
				 maxlength:'Máximo 4 Caracteres.'
			 },
			 dependienteHijo:{
				 required: 'Especifique Dependientes.',
				 number: 	'Solo Números',
				 maxlength:'Máximo 4 Caracteres.'
			 },
			 dependienteOtro:{
				 required: 'Especifique Dependientes.',
				 number: 	'Solo Números',
				 maxlength:'Maximo 4 Caracteres.'
			 },
			 especificarNegocio:{
				 required: 'Especifique de Quien Es.'
			 },
			 tipoOtroNuevoNegocio:{
				 required: 'Especifique Tipo de Negocio.',
				 maxlength:'Máximo 100 Caracteres.'
			 },
			 tipoProdTipoNeg:{
				 required: 'Especifique Tipo de Producto.',
				 maxlength:'Máximo 500 Caracteres.'
			 },
			 mercadoDeProdTipoNeg:{
				 required: 'Especifique Persona/Empresa.',
				 maxlength:'Máximo 200 Caracteres.'
			 },
			 ingresosMensTipoNeg:{
				 required: 'Especifique Ingresos Mensuales.',
			     number: 	'Solo Números.',
			     maxlength: 'Maximo 18 Caracteres.'
			 },
			 dependientesEconTipoNeg:{
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 dependienteHijoTipoNeg:{
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 dependienteOtroTipoNeg:{
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 tiempoNuevoNeg:{
				 required: 'Especifique Cuando.'
			 },
			 tiempoEnvio: {
				 required: 'Especifique Cuando.',
				 maxlength: 'Máximo 50 Caracteres.'
			 },
			 cuantoEnvio: {
				 required: 'Especifique Cuanto.',
				 maxlength:'Maximo 18 Caracteres.',
				 number: 'Sólo Números'
			 },
			 parentesOtroDet: {
				 required: 'Especifique Parentesco.'
			 },
			 trabajoActual: {
				 required: 'Especifique Trabajo.'
			 },
			 lugarTrabajoAct: {
				 required: 'Especifique Lugar.'
			 },
			 cargoTrabajo: {
				 required: 'Especifique Cargo.'
			 },
			 periodoDePago: {
				 required: 'Especifique Periodo.'
			 },
			 montoPeriodoPago: {
				 required: 'Especifique Monto.',
				 maxlength:'Maximo 18 Caracteres.',
				 number:'Sólo Números.'
			 },
			 tiempoLaborado: {
				 required: 'Especifique Tiempo.',
				 maxlength:'Máximo 100 Caracteres.'
			 },
			 dependientesEconSA: {
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 dependienteHijoSA: {
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 dependienteOtroSA: {
				 required: 'Especifique Dependientes.',
				 number: 'Solo Números.',
				 maxlength: 'Máximo 4 Caracteres.'
			 },
			 cargoPubPEPDet: {
				 required: 'Especifique el Cargo.'
			 },
			 nivelCargoPEP:{
				 required: 'Especifique Nivel.'				 
			 },
			 periodo1PEP: {
				 required: 'Especifique el Periodo.',
				 maxlength:'Máximo 50 Caracteres.'
			 },
			 periodo2PEP: {
				 required: 'Especifique el Periodo.',
				 maxlength:'Máximo 50 Caracteres.'
			 },
			 ingresosMenPEP: {
				 required: 'Especifique Ingresos Mensuales.',
				 number: 'Sólo Números.'
			 },
			 famEnCargoPEP: {
				 required: 'Especifíque Familiar.'							
			 },
			 nombreCompletoPEP: {
				 required: 'Especifique Nombre Completo.',
				 maxlength:'Máximo 100 Caracteres.'
			 },
			 nombreRelacionPEP: {
				 required: 'Especifique el Nombre.'
			 },
			 parentescoPEPDet: {
				 required: 'Especifique Parentesco.'
			 },
			 fuenteIngreOS: {
				 required: 'Especifique La Fuente de Ingresos.'				 
			 },
			 UbicFteIngreOS: {
				 required: 'Especifique Ubicación.'
			 },
			 ingMensualesOS: {
				 required: 'Especifique Ingresos Mensuales.',
				 maxlength:'Máximo 18 Caracteres.',
				 number:'Sólo Números.'
			 },
			 esPropioFteDet: {
				 required: 'Especifique de Quién.'
			 },
			 cargoPubPEPDetFam: {
				 required: 'Especifique Cargo.'
			 },
			 periodo1PEPFam: {
				 required: 'Especifique Periodo.'
			 },
			 periodo2PEPFam: {
				 required: 'Especifique Periodo.'
			 },
			 nombreCtoPEPFam:{
				 required: 'Especifique Nombre.'
			 },
			 nivelCargoPEPFam:{
				 required: 'Especifique el Nivel del Cargo.'
			 },
			 parentescoPEPFam:{
				 required: 'Especifique Parentesco.'
			 },
			 relacionPEP:{
				 required: 'Especifique Relación.'
			 },			
			 propietarioNombreCom:{
				 required: 'Especifique Nombre Completo.'
			 },
			 propietarioDomici: {
				 required: 'Especifique el Domicilio.'

			 },
			 propietarioNacio: {
				 required:'Especifique la Nacionalidad.'

			 },
			 propietarioCurp: {
				 required: 'Especifique el Curp.'

			 },
			 propietarioRfc: {
				 required: 'Especifique el RFC.'

			 },
			 propietarioFecha: {
				 required: 'Especifique Fecha.'

			 },
			 propietarioGener:{
				 required: 'Especifique Género.'

			 },
			 propietarioLugarNac:{
				 required: 'Especifique Lugar.'

			 },
			 propietarioEntid:{
				 required: 'Especifique Entidad.'

			 },
			 propietarioPais:{
				 required: 'Especifique el País.'

			 },
			 tipoProvRecursos:{
				 required: 	'Especifique Tipo de Proveedor.'
			 },
			 nombreCompProv:{
				 required: 	'Especifique el Nombre.'
			 },
			 domicilioProv:{
				 required:	'Especifique el Domicilio.'
			 },
			 fechaNacProv:{
				 required:	'Especifique una Fecha.'
			 },
			 nacionalidProv:{
				 required:	'Especifique la Nacionalidad.'
			 },
			 rfcProv:{
				 required:	'Especifique el RFC.'
			 },
			 razonSocialProvB:{
				 required:	'Especifique la Razon Social.'
			 },
			 nacionalidProvB:{
				 required:	'Especifique la Nacionalidad.'
			 },
			 rfcProvB:{
				 required:	'Especifique el RFC.'
			 },
			 domicilioProvB:{
				 required:	'Especifique el Domicilio.'
			 },
			 propietarioOcupac:{
				required: 'Especifique Ocupación.' 
			 },
			 observacionesEjec: {
				 required: 'Especifique Observaciones.'
			 },
			 parentescoPEP : {
				 required: 'Especifique Parentesco.'
			 },
			 otroAplDetalle:{
				 required: 'Especifique Motivo.'
			 },
			 cargoPubPEP:{
				 required: 'Especifique Cargo.'
			 },	
			 tipoNegocio:{
				 required: 'Especifique Tipo de Negocio.'
			 },
			 esPropioFteIng:{
				 required: 'Especifique si es Propia.'
			 },
			 esNegocioPropio:{
				 required: 'Especifique si es Propia.'
			 },
			 tipoNuevoNegocio:{
				 required: 'Espedifique Nuevo Tipo de Negocio.'
			 },
			 parentescoApert:{
				 required: 'Especifique Parentesco.'
			 },			 
			 fuenteRecursos:{
				 required: 'Especifique Fuente de Recursos.'
			 }
			
		 }		
	 });
	 
	 deshabilitaBoton('agrega', 'submit');
	 deshabilitaBoton('modifica', 'submit');
	 $('#clienteID').bind('keyup',function(){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	 });
	 
	 $('#clienteID').blur(function(){
		consultaCliente(this.id); 
	 });
	 
	 $('#agrega').click(function(){
		 $('#tipoTransaccion').val(Enum_Tra.agrega);
	 });
	 
	 $('#modifica').click(function(){
		 $('#tipoTransaccion').val(Enum_Tra.modifica);	
	 });	
	 
	 $('#otroAplCuest').click(function(){
		 $('#otroAplDetalle').show();
		 $('#otroAplDetalle').focus();
	 });
	 $('.clAplcCuest').click(function(){
		 $('#otroAplDetalle').hide();
		 $('#otroAplDetalle').val('');
		 
	 });
	 
	 $('#realizadoOpSI').click(function(){
		 $('#divFuenteRecursos').show(200);
		 if( $('#fuenteOtra').is(':checked')){	
				$('#fuenteOtraDet').attr('readOnly',false);
			}else{				
				$('#fuenteOtraDet').attr('readOnly',true);		
			}
		
	 });
 
	 
	 $('#realizadoOpNO').click(function(){
		 inicializaPantalla();
	 });	 
	 
	 $('#fuenteApoyoGuber').click(function(){
		 limpiaOtrosServi();
		 limpiaFisicaCAcA();
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();
		 limpiaPropReal();
		 limpiaPerPolExpSI();
		 limpiaPolExpFam();
		 limpiaProveedRecA();
		 limpiaProveedRecB();
		 $('#fuenteOtraDet').attr('readOnly',true);
		 $('#fuenteOtraDet').val('');
		 $('#proveedRecursosP').attr('checked',false);
		 $('#proveedPFisica').attr('checked',false);
		 $('#proveedPMoral').attr('checked',false);
		 $('#tipoApertNuev').attr('checked',false);
		 $('#tipoFamiliarExt').attr('checked',false);
		 $('#tipoCambioTrab').attr('checked',false);
		 $('#tipoOtroNuevo').attr('checked',false);
		 $('#cargoPubPEPSi').attr('checked',false);
		 $('#cargoPubPEPSO').attr('checked',false);
		 $('#cargoPubPEPFa').attr('checked',false);
		 $('#cargoPubPEPNo').attr('checked',false);
		 $('#incrementoVentas').attr('checked',false);
		 $('#ingresoAdiciSi').attr('checked',false);
		 $('#ingresoAdiciNo').attr('checked',false);
		 
		 
		 $('#divPersonasFisicEmp').hide(200);
		 $('#divPersonasSinAct').hide(200);
		 $('#divOtrosServicios').hide(200);
		 $('#divProveedoresRec').hide(200);
		 $('#divPropietarioReal').hide(200);
		 $('#divPersonasPEPS').hide(200);
		 
	 });
	 $('#fuenteComer').click(function(){
		 $('#divPropietarioReal').show(200);
		 $('#divPersonasPEPS').show(200);
		 $('#divPersonasFisicEmp').show(200);
		 $('#divPersonasSinAct').show(200);
		 $('#fuenteOtraDet').attr('readOnly',true);
		 $('#fuenteOtraDet').val('');
		 $('#proveedRecursosP').attr('checked',false);
		 $('#proveedPFisica').attr('checked',false);
		 $('#proveedPMoral').attr('checked',false);
		 $('#ingresoAdiciSi').attr('checked',false);
		 $('#ingresoAdiciNo').attr('checked',false);
		 $('#tipoOtroNuevo').attr('checked',false);
		 
		 
		 limpiaOtrosServi();
		 limpiaProveedRecA();
		 limpiaProveedRecB();
		 
		 $('#divOtrosServicios').hide(200);
		 $('#divProveedoresRec').hide(200);
	 });	 
	 $('#fuenteNuevaAct').click(function(){
		$('#divPropietarioReal').show(200);
		$('#divPersonasPEPS').show(200);
		$('#divProveedoresRec').show(200);
				
		limpiaFisicaCAcA();
		limpiaFisicaCAcB();
		limpiaFisicaSAcB();
		limpiaFisicaSAcC();
		limpiaOtrosServi();
		
		$('#fuenteOtraDet').val('');
		$('#fuenteOtraDet').attr('readOnly',true);
		$('#proveedRecursosP').attr('checked',true);
		$('#tipoApertNuev').attr('checked',false);
		$('#tipoFamiliarExt').attr('checked',false);
		$('#tipoCambioTrab').attr('checked',false);
		$('#tipoOtroNuevo').attr('checked',false);
		$('#incrementoVentas').attr('checked',false);
		$('#negocioNuevoTipo').attr('checked',false);
		$('#ingresoAdiciSi').attr('checked',false);
		$('#ingresoAdiciNo').attr('checked',false);
		 		
		$('#divPersonasFisicEmp').hide(200);
		$('#divPersonasSinAct').hide(200);
		$('#divOtrosServicios').hide(200);		
	 });
	 
	 $('#fuenteOtra').click(function(){
		 $('#divOtrosServicios').show(200);
		 
		 limpiaFisicaCAcA();
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();
		 limpiaPropReal();
		 limpiaPerPolExpSI();
		 limpiaPolExpFam();
		 limpiaProveedRecA();
		 limpiaProveedRecB();
		 $('#fuenteOtraDet').attr('readOnly',false); 
		 $('#proveedPFisica').attr('checked',false);
		 $('#proveedPMoral').attr('checked',false);
		 $('#tipoApertNuev').attr('checked',false);
		 $('#tipoFamiliarExt').attr('checked',false);
		 $('#tipoCambioTrab').attr('checked',false);
		 $('#tipoOtroNuevo').attr('checked',false);
		 $('#cargoPubPEPSi').attr('checked',false);
		 $('#cargoPubPEPSO').attr('checked',false);
		 $('#cargoPubPEPFa').attr('checked',false);
		 $('#cargoPubPEPNo').attr('checked',false);
		 $('#proveedRecursosP').attr('checked',false);
		 $('#ingresoAdiciSi').attr('checked',false);
		 $('#ingresoAdiciNo').attr('checked',false);
		 $('#incrementoVentas').attr('checked',false);
		 
		 $('#divProveedoresRec').hide(200);
		 $('#divPersonasFisicEmp').hide(200);
		 $('#divPersonasSinAct').hide(200);
		 $('#divPropietarioReal').hide(200);
		 $('#divPersonasPEPS').hide(200);		 
	 });
	 
	 $('#fuenteProvRecur').click(function(){
		$('#divPropietarioReal').show(200);
		$('#divPersonasPEPS').show(200);
		$('#divProveedoresRec').show(200);
		
		limpiaFisicaCAcA();
		limpiaFisicaCAcB();
		limpiaFisicaSAcB();
		limpiaFisicaSAcC();
		limpiaOtrosServi();
		
		$('#fuenteOtraDet').val('');
		$('#fuenteOtraDet').attr('readOnly',true);
		$('#proveedRecursosP').attr('checked',true);
		$('#tipoApertNuev').attr('checked',false);
		$('#tipoFamiliarExt').attr('checked',false);
		$('#tipoCambioTrab').attr('checked',false);
		$('#tipoOtroNuevo').attr('checked',false);
		$('#incrementoVentas').attr('checked',false);
		$('#negocioNuevoTipo').attr('checked',false);
		$('#ingresoAdiciSi').attr('checked',false);
		$('#ingresoAdiciNo').attr('checked',false);
		

			
		$('#divPersonasFisicEmp').hide(200);
		$('#divPersonasSinAct').hide(200);
		$('#divOtrosServicios').hide(200); 
	 });
	 
	 $('#esNegocioPropioSI').click(function(){
		$('#lblEspecifiqueQuien').hide();
		$('#tdEspecifiqueQuien').hide();
	 });
	 $('#esNegocioPropioNO').click(function(){
		$('#lblEspecifiqueQuien').show();
		$('#tdEspecifiqueQuien').show();
		$('#especificarNegocio').focus();
	 });
	 
	 $('#incrementoVentas').click(function(){
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();		 
		 $('#divIncrementoVentas').show(200);
		 $('#divNuevoTipoNeg').hide(200);
		 $('#divFamiliarExt').hide(200);
		 $('#divCambioTrabajo').hide(200);
		 $('#divOtrosServicios').hide(200);

		 $('#tipoApertNuev').attr('checked',false);
		 $('#tipoFamiliarExt').attr('checked',false);
		 $('#tipoCambioTrab').attr('checked',false);
		 $('#tipoOtroNuevo').attr('checked',false);
	 });
	 
	 $('#negocioNuevoTipo').click(function(){
		 limpiaFisicaCAcA();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();
		 
		 $('#divNuevoTipoNeg').show(200);
		 $('#divIncrementoVentas').hide(200);
		 $('#divFamiliarExt').hide(200);
		 $('#divCambioTrabajo').hide(200);
		 $('#divOtrosServicios').hide(200);
		 $('#tipoApertNuev').attr('checked',false);
		 $('#tipoFamiliarExt').attr('checked',false);
		 $('#tipoCambioTrab').attr('checked',false);
		 $('#tipoOtroNuevo').attr('checked',false);
		 
	 });
	 
	 $('#tipoApertNuev').click(function(){
		 limpiaFisicaCAcA();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();
		 $('#divFamiliarExt').hide(200);
		 $('#divCambioTrabajo').hide(200);
		 $('#divOtrosServicios').hide(200);
		 $('#divIncrementoVentas').hide(200);
		 $('#divNuevoTipoNeg').show(200);
		 if($('#negocioNuevoTipo').attr('checked')== false){
			 $('#negocioNuevoTipo').attr('checked',true);
			 mensajeSis('Llenar el Apartado de Personas Físicas con Actividad Empresarial Opción Nuevo Tipo de Negocio.');
		 
		 }
	 });
	 
	 
	 
	 $('#tipoFamiliarExt').click(function(){
		 $('#ingresoAdiciNo').attr('checked',false);
		 $('#incrementoVentas').attr('checked',false);
		 $('#negocioNuevoTipo').attr('checked',false);
		 limpiaFisicaCAcA();
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcC();
		 limpiaOtrosServi();
		 
		 $('#divFamiliarExt').show(200);
		 $('#divOtrosServicios').hide(200);
		 $('#divCambioTrabajo').hide(200);
		 $('#divIncrementoVentas').hide(200);
		 $('#divNuevoTipoNeg').hide(200);
		 $('#tiempoNuevoNeg').focus();
	 });
	 
	 $('#tipoCambioTrab').click(function(){
		 $('#ingresoAdiciNo').attr('checked',false);
		 $('#incrementoVentas').attr('checked',false);
		 $('#negocioNuevoTipo').attr('checked',false);
		 limpiaFisicaCAcA();
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcB();
		 limpiaOtrosServi();
		 
		 $('#divCambioTrabajo').show(200);
		 $('#divFamiliarExt').hide(200);
		 $('#divOtrosServicios').hide(200);
		 $('#divIncrementoVentas').hide(200);
		 $('#divNuevoTipoNeg').hide(200);
		 $('#trabajoActual').focus();
	 });
	 
	 $('#tipoOtroNuevo').click(function(){
		 $('#ingresoAdiciNo').attr('checked',false);
		 $('#incrementoVentas').attr('checked',false);
		 $('#negocioNuevoTipo').attr('checked',false);
		 limpiaFisicaCAcA();
		 limpiaFisicaCAcB();
		 limpiaFisicaSAcB();
		 limpiaFisicaSAcC();
		 limpiaOtrosServi();
		 
		 $('#divOtrosServicios').show(200);
		 $('#divFamiliarExt').hide(200);
		 $('#divCambioTrabajo').hide(200);
		 $('#divIncrementoVentas').hide(200);
		 $('#divNuevoTipoNeg').hide(200);
	 });
	 
	 
	 $('#proveedPFisica').click(function(){
		 limpiaProveedRecB();
		 $('#divApartadoA').show(200);
		 $('#divApartadoB').hide(200);
		 
		 
	 });
	 $('#proveedPMoral').click(function(){
		 limpiaProveedRecA();
		 $('#divApartadoB').show(200);
		 $('#divApartadoA').hide(200);
	 });
	 
	 $('#cargoPubPEPNo').click(function(){
		 limpiaPerPolExpSI();
		 limpiaPolExpFam();
		 $('#divApartadoAPEP').hide(200);
		 $('#divApartadoBPEP').hide(200);		 
	 });
	 $('#cargoPubPEPSi').click(function(){
		 limpiaPolExpFam();
		 $('#divApartadoAPEP').show(200);
		 $('#divApartadoBPEP').hide(200);
	 });
	 $('#cargoPubPEPSO').click(function(){
		 limpiaPolExpFam();
		 $('#divApartadoAPEP').show(200);
		 $('#divApartadoBPEP').hide(200);
	 });
	 $('#cargoPubPEPFa').click(function(){
		 limpiaPerPolExpSI();
		 $('#divApartadoAPEP').hide(200);
		 $('#divApartadoBPEP').show(200);
	 });
	 
	 
	 $('#ingresoAdiciSi').click(function(){		 		 
		 $('#divOtrosServiciosSI').show(200);
	 });
	 $('#ingresoAdiciNo').click(function(){		 
		 limpiaOtrosServi();
		 $('#divOtrosServiciosSI').hide(200);
	 });
	 
	 $('#tipoOtroNuev').click(function(){
		 $('#tipoOtroNuevoNegocio').show();
		 $('#tipoOtroNuevoNegocio').focus();
	 });
	 
	 $('.clTipoNuevo').click(function(){
		 $('#tipoOtroNuevoNegocio').hide();
	 });
	 
	 $('#parentescoOtro').click(function(){
		$('#parentesOtroDet').show();
		$('#parentesOtroDet').focus();
	 });
	$('.clParentApert').click(function(){
		$('#parentesOtroDet').hide();
	});
	 
	$('#propietarioOtro').click(function(){
		$('#tdPropOtroDet').show();
		$('#propietarioOtroDet').focus();
	});
	$('#propietarioFam').click(function(){
		$('#tdPropOtroDet').hide();
		$('#propietarioOtroDet').val('');
	});
	
	$('#parentescoPEPFOtr').click(function(){
		$('#parentescoPEPDet').show();
		$('#parentescoPEPDet').focus();
	});
	$('.clParentPEP').click(function(){
		$('#parentescoPEPDet').hide();
	});
	
	$('#esPropioFteIngNo').click(function(){
		$('#tdEspecifiqlbl').show();
		$('#tdEsPropioDet').show();
		$('#esPropioFteDet').focus();
	});
	$('#esPropioFteIngSi').click(function(){
		$('#tdEspecifiqlbl').hide();
		$('#tdEsPropioDet').hide();
	});
	
	$('#tipoOtro').click(function(){
		habilitaControl('tipoOtroNegocio');
	});	
	
	$('.tnActEmp').click(function(){
		deshabilitaControl('tipoOtroNegocio');
		$('#tipoOtroNegocio').val('');
		
	});
	
	$('#propietarioFecha').change(function(){
		var Xfecha= $('#propietarioFecha').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#propietarioFecha').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Nacimiento No puede ser Mayor a la Fecha del Sistema")	;
				$('#propietarioFecha').val(parametroBean.fechaSucursal);
				regresarFoco('propietarioFecha');
			}else{
				if(!esTab){
					regresarFoco('propietarioFecha');
				}
				$('#propietarioFecha').val($('#propietarioFecha').val());
			}
		}else{
			$('#propietarioFecha').val(parametroBean.fechaSucursal);
			regresarFoco('propietarioFecha');
		}
	});
	
	$('#fechaNacProv').change(function(){
		var Xfecha= $('#fechaNacProv').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNacProv').val(parametroBean.fechaSucursal);
			var Yfecha= parametroBean.fechaAplicacion;
			if( mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Nacimiento No puede ser Mayor a la Fecha del Sistema")	;
				$('#fechaNacProv').val(parametroBean.fechaSucursal);
				regresarFoco('fechaNacProv');
			}else{
				if(!esTab){
					regresarFoco('fechaNacProv');
				}
				$('#fechaNacProv').val($('#fechaNacProv').val());
			}
		}else{
			$('#fechaNacProv').val(parametroBean.fechaSucursal);
			regresarFoco('fechaNacProv');
		}
	});
	
	
	$('#propietarioPais').blur(function(){
		$('#cargoPubPEPSi').focus();
	});
	
	$('#imprimir').click(function(){
		generaPDF();
	});
	
	function generaPDF(){
		var tr= 1;
		
		var clienteID =$('#clienteID').val();
		var promotorID = $('#promotorID').val();
	
		/// VALORES TEXTO
		var nombreCliente = $('#nombreCliente').val();
		var nombrePromotor = $('#nombrePromotor').val();
		var nombreUsuario = parametroBean.nombreUsuario;
		var nombreSucursal = parametroBean.nombreSucursal;
		var direccionSucursal = parametroBean.edoMunSucursal;
		var fechaEmision = parametroBean.fechaSucursal;

		$('#ligaGenerar').attr('href','repIdentificacionCtePDF.htm?tipoReporte='+tr
				+'&clienteID='+clienteID+'&promotorID='+promotorID+'&nombreCliente='+nombreCliente+'&nombrePromotor='
				+nombrePromotor+'&nombreUsuario='+nombreUsuario+'&nombreSucursal='+nombreSucursal+'&direccionSucursal='+
				direccionSucursal+'&fechaSistema='+fechaEmision);
	}
	
	 function consultaCliente(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConPrincipal = 1;
			setTimeout("$('#cajaLista').hide();", 200);					
			if(numCliente != '' && !isNaN(numCliente) && numCliente.length){
				clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
					if(cliente!=null){	
						$('#clienteID').val(cliente.numero)	;						
						$('#nombreCliente').val(cliente.nombreCompleto);
						$('#promotorID').val(cliente.promotorActual);
						$('#sucursalID').val(cliente.sucursalOrigen);
						consultaPromotor($('#promotorID').val());
						consultaSucursal($('#sucursalID').val());						
						habilitaBoton('modifica', 'submit');
						habilitaBoton('imprimir','button');
						
					}else{
						mensajeSis("No Existe el Cliente");
						limpiaPantalla();
						deshabilitaBoton('agrega','submit');
						deshabilitaBoton('modifica','submit');
						$('#clienteID').focus();
					}    	 						
				});
			}
		}
	 
	 
	 function consultaPromotor(numPromotor) {		
			var tipConForanea = 2;	
			var promotor = {
					'promotorID' : numPromotor
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numPromotor == '' || numPromotor==0){
				$(jqPromotor).val(0);
			}else{
				if(numPromotor != '' && !isNaN(numPromotor) ){ 
					promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
						if(promotor!=null){							
							$('#nombrePromotor').val(promotor.nombrePromotor); 

						}else{
							mensajeSis("No Existe el Promotor");
							limpiaPantalla();
							deshabilitaBoton('agrega','submit');
							deshabilitaBoton('modifica','submit');
							$('#clienteID').focus();
						}    	 						
					});
				}
			}
	 }
	 
	function consultaSucursal(numSucursal) {		
			var conSucursal = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursal').val(sucursal.nombreSucurs);
					consultaCuestionario($('#clienteID').val());					
				} else {
					mensajeSis("No Existe la Sucursal");
					limpiaPantalla();
					deshabilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					$('#clienteID').focus();
				}
			});
	}
	
	function consultaCuestionario(numCliente){
		var consultaPrincipal=1;
		var cuestionarioBean={
			'clienteID' : numCliente
		};
		
		identidadClienteServicio.consulta(cuestionarioBean, consultaPrincipal, function(cuestionario){
			if(cuestionario!=null){
				inicializaPantalla();
				limpiaCuestPrincipal();
				consultaCuestionarioCliente(cuestionario);
				habilitaBoton('modifica','submit');
				deshabilitaBoton('agrega','submit');
				$('#divCuestionarioPrin').show(200);
				$('#tdObservaciones').show();
				$('#imprimir').show();
			}else{
				inicializaPantalla();
				limpiaCuestPrincipal();
				habilitaBoton('agrega','submit');
				deshabilitaBoton('modifica','submit');
				$('#divCuestionarioPrin').show(200);
				$('#tdObservaciones').show();
				$('#imprimir').hide();
			}
		});
	};

	
	function consultaCuestionarioCliente(cuestionario){
		switch(cuestionario.aplicaCuest){
			case 'A':
				$('#actAltoRiesgo').attr('checked',true);
				break;
			case 'P':
				$('#peps').attr('checked',true);
				break;
			case 'C':
				$('#cambioPerfil').attr('checked',true);
				break;
			case 'O':
				$('#otroAplCuest').attr('checked',true);
				$('#otroAplDetalle').show();
				$('#otroAplDetalle').val(cuestionario.otroAplDetalle);
				break;
		}
		switch(cuestionario.realizadoOp){
			case 'S':
				$('#realizadoOpSI').attr('checked',true);
				$('#divFuenteRecursos').show(200);
				switch(cuestionario.fuenteRecursos){
					case 'A':
						$('#fuenteApoyoGuber').attr('checked',true);
						break;
						
					case 'C':
						$('#fuenteComer').attr('checked',true);
						$('#divPropietarioReal').show();
						$('#divPersonasPEPS').show();
						$('#divPersonasFisicEmp').show();
						$('#divPersonasSinAct').show();
						switch(cuestionario.negocioPersona){
							case 'I':
								$('#incrementoVentas').attr('checked',true);	
								$('#divIncrementoVentas').show();
								switch(cuestionario.tipoNegocio){
									case 'F':
										$('#tipoFijo').attr('checked',true);
										break;
									case 'S':
										$('#tipoSemifijo').attr('checked',true);
										break;
									case 'A':
										$('#tipoAmbulante').attr('checked',true);
										break;
									case 'O':
										$('#tipoOtro').attr('checked',true);
										$('#tipoOtroNegocio').val(cuestionario.tipoOtroNegocio);
										break;
								}
								$('#giroNegocio').val(cuestionario.giroNegocio);
								$('#aniosAntig').val(cuestionario.aniosAntig);
								$('#mesesAntig').val(cuestionario.mesesAntig);
								$('#ubicacNegocio').val(cuestionario.ubicacNegocio);
								$('#tipoProducto').val(cuestionario.tipoProducto);
								$('#mercadoDeProducto').val(cuestionario.mercadoDeProducto);
								$('#ingresosMensuales').val(cuestionario.ingresosMensuales);
								$('#dependientesEcon').val(cuestionario.dependientesEcon);
								$('#dependienteHijo').val(cuestionario.dependienteHijo);
								$('#dependienteOtro').val(cuestionario.dependienteOtro);
								
								switch(cuestionario.esNegocioPropio){
								case 'S':
									$('#esNegocioPropioSI').attr('checked',true);
									break;
								case 'N':
									$('#esNegocioPropioNO').attr('checked',true);
									$('#lblEspecifiqueQuien').show();
									$('#tdEspecifiqueQuien').show();
									$('#especificarNegocio').val(cuestionario.especificarNegocio);
									break;
								}
								break;
							case 'N':
								$('#negocioNuevoTipo').attr('checked',true);
								$('#divNuevoTipoNeg').show();
								$('#tipoProdTipoNeg').val(cuestionario.tipoProdTipoNeg);
								$('#mercadoDeProdTipoNeg').val(cuestionario.mercadoDeProdTipoNeg);
								$('#ingresosMensTipoNeg').val(cuestionario.ingresosMensTipoNeg);
								$('#dependientesEconTipoNeg').val(cuestionario.dependientesEconTipoNeg);
								$('#dependienteHijoTipoNeg').val(cuestionario.dependienteHijoTipoNeg);
								$('#dependienteOtroTipoNeg').val(cuestionario.dependienteOtroTipoNeg);
								
								switch(cuestionario.tipoNuevoNegocio){
									case 'F':
										$('#tipoFijoNuev').attr('checked',true);
										break;
									case 'S':
										$('#tipoSemifijoNuev').attr('checked',true);
										break;
									case 'A':
										$('#tipoAmbulanteNuev').attr('checked',true);
										break;
									case 'O':
										$('#tipoOtroNuev').attr('checked',true);
										$('#tipoOtroNuevoNegocio').show();
										$('#tipoOtroNuevoNegocio').val(cuestionario.tipoOtroNuevoNegocio);
										break;
								}
								break;
						}
						switch(cuestionario.fteNuevosIngresos){
							case 'A':
								$('#tipoApertNuev').attr('checked',true);
								break;
							case 'F':
								$('#tipoFamiliarExt').attr('checked',true);
								$('#divFamiliarExt').show();
								$('#tiempoNuevoNeg').val(cuestionario.tiempoNuevoNeg);
								$('#tiempoEnvio').val(cuestionario.tiempoEnvio);
								$('#cuantoEnvio').val(cuestionario.cuantoEnvio);
								
								switch(cuestionario.parentescoApert){
									case 'H':
										$('#parentescoHijo').attr('checked',true);
										break;
									case 'C':
										$('#parentescoConyuge').attr('checked',true);
										break;
									case 'E':
										$('#parentescoHermano').attr('checked',true);
										break;
									case 'O':
										$('#parentescoOtro').attr('checked',true);
										$('#parentesOtroDet').show();
										$('#parentesOtroDet').val(cuestionario.parentesOtroDet);
										break;
								}
								break;
							case 'C':
									$('#tipoCambioTrab').attr('checked',true);
									$('#divCambioTrabajo').show();
									$('#trabajoActual').val(cuestionario.trabajoActual);
									$('#lugarTrabajoAct').val(cuestionario.lugarTrabajoAct);
									$('#cargoTrabajo').val(cuestionario.cargoTrabajo);
									$('#periodoDePago').val(cuestionario.periodoDePago);
									$('#montoPeriodoPago').val(cuestionario.montoPeriodoPago);
									$('#tiempoLaborado').val(cuestionario.tiempoLaborado);
									$('#dependientesEconSA').val(cuestionario.dependientesEconSA);
									$('#dependienteHijoSA').val(cuestionario.dependienteHijoSA);
									$('#dependienteOtroSA').val(cuestionario.dependienteOtroSA);
								break;
							case 'O':
								consultaOtrosServicios(cuestionario);
								break;
						}
						consultaPropReal(cuestionario);
						consultaPersonasPEPS(cuestionario);
						break;
					case 'N':
						$('#fuenteNuevaAct').attr('checked',true);
						$('#divProveedoresRec').show();
						$('#divPropietarioReal').show();
						$('#divPersonasPEPS').show();
						consultaProveedRec(cuestionario);
						consultaPropReal(cuestionario);
						consultaPersonasPEPS(cuestionario);
						break;
					case 'P':
						$('#fuenteProvRecur').attr('checked',true);
						$('#divProveedoresRec').show();
						$('#divPropietarioReal').show();
						$('#divPersonasPEPS').show();
						consultaProveedRec(cuestionario);
						consultaPropReal(cuestionario);
						consultaPersonasPEPS(cuestionario);
						break;
					case 'O':
						$('#fuenteOtra').attr('checked',true);
						$('#fuenteOtraDet').val(cuestionario.fuenteOtraDet);
						$('#divPropietarioReal').hide();
						$('#divPersonasPEPS').hide();
						
						consultaOtrosServicios(cuestionario);
						break;
				}
				break;
			case 'N':
				$('#realizadoOpNO').attr('checked',true);
				break;
		}
		$('#observacionesEjec').val(cuestionario.observacionesEjec);
		if($('#fuenteOtra').is(':checked')){
			$('#fuenteOtraDet').attr('readOnly',false);
			
		}else{
			$('#fuenteOtraDet').attr('readOnly',true);
		}
		actualizaFormatoMoneda('formaGenerica');
	}
	
	
	function consultaOtrosServicios(cuestionario){
		$('#tipoOtroNuevo').attr('checked',true);
		$('#divOtrosServicios').show();
		switch(cuestionario.ingresoAdici){
			case 'S':
				$('#ingresoAdiciSi').attr('checked',true);
				$('#divOtrosServiciosSI').show();
				$('#fuenteIngreOS').val(cuestionario.fuenteIngreOS);
				$('#ingMensualesOS').val(cuestionario.ingMensualesOS);
				$('#UbicFteIngreOS').val(cuestionario.ubicFteIngreOS);
				switch(cuestionario.esPropioFteIng){
					case 'S':
						$('#esPropioFteIngSi').attr('checked',true);
						break;
					case 'N':
						$('#esPropioFteIngNo').attr('checked',true);
						$('#tdEspecifiqlbl').show();
						$('#tdEsPropioDet').show();
						$('#esPropioFteDet').val(cuestionario.esPropioFteDet);
						break;
				}
				break;
			case 'N':
				$('#ingresoAdiciNo').attr('checked',true);
				break;
		}
		
	}
	
	function consultaProveedRec(cuestionario){
		$('#proveedRecursosP').attr('checked',true);
		switch(cuestionario.tipoProvRecursos){
			case 'F':	
					$('#proveedPFisica').attr('checked',true);
					$('#divApartadoA').show();
					$('#nombreCompProv').val(cuestionario.nombreCompProv);
					$('#domicilioProv').val(cuestionario.domicilioProv);
					$('#fechaNacProv').val(cuestionario.fechaNacProv);
					$('#nacionalidProv').val(cuestionario.nacionalidProv);
					$('#rfcProv').val(cuestionario.rfcProv);
				break;
			case 'M':
					$('#proveedPMoral').attr('checked',true);
					$('#divApartadoB').show();	
					$('#razonSocialProvB').val(cuestionario.razonSocialProvB);
					$('#nacionalidProvB').val(cuestionario.nacionalidProvB);
					$('#rfcProvB').val(cuestionario.rfcProvB);
					$('#domicilioProvB').val(cuestionario.domicilioProvB);

				break;
		}
	}
	
	function consultaPropReal(cuestionario){
		$('#propietarioNombreCom').val(cuestionario.propietarioNombreCom);
		$('#propietarioDomici').val(cuestionario.propietarioDomici);
		$('#propietarioNacio').val(cuestionario.propietarioNacio);
		$('#propietarioCurp').val(cuestionario.propietarioCurp);
		$('#propietarioRfc').val(cuestionario.propietarioRfc);
		$('#propietarioGener').val(cuestionario.propietarioGener);
		$('#propietarioOcupac').val(cuestionario.propietarioOcupac);
		if(cuestionario.propietarioFecha!='1900-01-01'){
			$('#propietarioFecha').val(cuestionario.propietarioFecha);
		}		
		$('#propietarioLugarNac').val(cuestionario.propietarioLugarNac);
		$('#propietarioEntid').val(cuestionario.propietarioEntid);
		$('#propietarioPais').val(cuestionario.propietarioPais);
		switch(cuestionario.propietarioDinero){
			case 'F':
					$('#propietarioFam').attr('checked',true);
				break;
			case 'O':
					$('#propietarioOtro').attr('checked',true);
					$('#tdPropOtroDet').show();
					$('#propietarioOtroDet').val(cuestionario.propietarioOtroDet);
				break;
		}
	}
	
	function consultaPersonasPEPS(cuestionario){
		switch(cuestionario.cargoPubPEP ){
			case 'O':
			case 'A':	
				$('#divApartadoAPEP').show();
				if(cuestionario.cargoPubPEP=='O'){
					$('#cargoPubPEPSi').attr('checked',true);
				}else{
					$('#cargoPubPEPSO').attr('checked',true);
				}
				$('#cargoPubPEPDet').val(cuestionario.cargoPubPEPDet);
				$('#periodo1PEP').val(cuestionario.periodo1PEP);
				$('#periodo2PEP').val(cuestionario.periodo2PEP);
				$('#ingresosMenPEP').val(cuestionario.ingresosMenPEP);
				$('#nombreCompletoPEP').val(cuestionario.nombreCompletoPEP);
				switch(cuestionario.nivelCargoPEP){
					case 'F':
						$('#nivelFederalPEP').attr('checked',true);	
						break;
					case 'E':
						$('#nivelEstatalPEP').attr('checked',true);
						break;
					case 'M':
						$('#nivelMunicipalPEP').attr('checked',true);
						break;
				}
				switch(cuestionario.famEnCargoPEP){
					case 'S':
						$('#famEnCargoPEPSi').attr('checked',true);
						break;
					case 'N':
						$('#famEnCargoPEPNo').attr('checked',true);
						break;
				}
				switch(cuestionario.parentescoPEP){
					case 'P':
						$('#parentescoPEPPad').attr('checked',true);
						break;
					case 'M':
						$('#parentescoPEPMad').attr('checked',true);
						break;
					case 'H':
						$('#parentescoPEPHij').attr('checked',true);
						break;
				}
				break;
			case 'F':
				$('#divApartadoBPEP').show();
				$('#cargoPubPEPFa').attr('checked',true);
				$('#cargoPubPEPDetFam').val(cuestionario.cargoPubPEPDetFam);
				$('#periodo1PEPFam').val(cuestionario.periodo1PEPFam);
				$('#periodo2PEPFam').val(cuestionario.periodo2PEPFam);
				$('#nombreCtoPEPFam').val(cuestionario.nombreCtoPEPFam);
				$('#nombreRelacionPEP').val(cuestionario.nombreRelacionPEP);
				switch(cuestionario.nivelCargoPEPFam){
					case 'F':
						$('#nivelFederalPEPF').attr('checked',true);	
						break;
					case 'E':
						$('#nivelEstatalPEPF').attr('checked',true);
						break;
					case 'M':
						$('#nivelMunicipalPEPF').attr('checked',true);
						break;
				}			
				switch(cuestionario.parentescoPEPFam){
				case 'P':
					$('#parentescoPEPFPad').attr('checked',true);
					break;
				case 'M':
					$('#parentescoPEPFMad').attr('checked',true);
					break;
				case 'H':
					$('#parentescoPEPFHij').attr('checked',true);
					break;
				case 'O':
					$('#parentescoPEPFOtr').attr('checked',true);
					$('#parentescoPEPDet').show();
					$('#parentescoPEPDet').val(cuestionario.parentescoPEPDet);
					break;
				}
				switch(cuestionario.relacionPEP){
				case 'S':
					$('#relacionPEPSi').attr('checked',true);	
					break;
				case 'N':
					$('#relacionPEPNo').attr('checked',true);
					break;
				}
				break;
			case 'N':	
				$('#cargoPubPEPNo').attr('checked',true);
				break;
		}
	}
	
	function limpiaPantalla(){
		$('#clienteID').val('')	;	
		$('#nombreCliente').val('');
		$('#sucursalID').val('');
		$('#nombreSucursal').val('');
		$('#promotorID').val('');
		$('#nombrePromotor').val('');
	}
	
	function limpiaFisicaCAcA(){
		$('#tipoFijo').attr('checked',false);
		$('#tipoSemifijo').attr('checked',false);
		$('#tipoAmbulante').attr('checked',false);
		$('#tipoOtro').attr('checked',false);
		
		$('#esNegocioPropioSI').attr('checked',false);
		$('#esNegocioPropioNO').attr('checked',false);
		$('#especificarNegocio').val('');
		$('#tipoOtroNegocio').val('');
		$('#giroNegocio').val('');
		$('#aniosAntig').val('');
		$('#mesesAntig').val('');
		$('#ubicacNegocio').val('');
		$('#tipoProducto').val('');
		$('#mercadoDeProducto').val('');
		$('#ingresosMensuales').val('');
		$('#dependientesEcon').val('');
		$('#dependienteHijo').val('');
		$('#dependienteOtro').val('');
		$('#lblEspecifiqueQuien').hide();
		$('#tdEspecifiqueQuien').hide();
	}
	
	function limpiaFisicaCAcB(){
		$('#tipoFijoNuev').attr('checked',false);
		$('#tipoSemifijoNuev').attr('checked',false);
		$('#tipoAmbulanteNuev').attr('checked',false);
		$('#tipoOtroNuev').attr('checked',false);
		
		$('#tipoProdTipoNeg').val('');
		$('#mercadoDeProdTipoNeg').val('');
		$('#ingresosMensTipoNeg').val('');
		$('#dependientesEconTipoNeg').val('');
		$('#dependienteHijoTipoNeg').val('');
		$('#dependienteOtroTipoNeg').val('');
		$('#tipoOtroNuevoNegocio').hide();
	}
	
	function limpiaFisicaSAcB(){
		$('#parentesOtroDet').val('');
		$('#parentesOtroDet').hide();
		$('#parentescoConyuge').attr('checked',false);
		$('#parentescoHermano').attr('checked',false);
		$('#parentescoOtro').attr('checked',false);
		$('#parentescoHijo').attr('checked',false);
		$('#tiempoNuevoNeg').val('');
		$('#tiempoEnvio').val('');
		$('#cuantoEnvio').val('');
	}
	
	function limpiaFisicaSAcC(){
		$('#trabajoActual').val('');
		$('#lugarTrabajoAct').val('');
		$('#cargoTrabajo').val('');
		$('#periodoDePago').val('');
		$('#montoPeriodoPago').val('');
		$('#tiempoLaborado').val('');
		$('#dependientesEconSA').val('');
		$('#dependienteHijoSA').val('');
		$('#dependienteOtroSA').val('');
	}
	function limpiaProveedRecA(){
		$('#nombreCompProv').val('');
		$('#domicilioProv').val('');
		$('#fechaNacProv').val('');
		$('#nacionalidProv').val('');
		$('#rfcProv').val('');
	}
	
	function limpiaProveedRecB(){
		$('#razonSocialProvB').val('');
		$('#nacionalidProvB').val('');
		$('#rfcProvB').val('');
		$('#domicilioProvB').val('');
	}
	
	function limpiaOtrosServi(){		
		$('#esPropioFteDet').val('');
		$('#tdEsPropioDet').hide();
		$('#tdEspecifiqlbl').hide();
		$('#esPropioFteIngSi').attr('checked',false);
		$('#esPropioFteIngNo').attr('checked',false);
		$('#fuenteIngreOS').val('');
		$('#UbicFteIngreOS').val('');
		$('#ingMensualesOS').val('');
	}
	
	function limpiaPropReal(){
		$('#propietarioOtroDet').val('');		
		$('#propietarioOtro').attr('checked',false);
		$('#propietarioFam').attr('checked',false);
		
		$('#propietarioNombreCom').val('');
		$('#propietarioDomici').val('');
		$('#propietarioNacio').val('');
		$('#propietarioCurp').val('');
		$('#propietarioRfc').val('');
		$('#propietarioGener').val('');
		$('#propietarioOcupac').val('');
		$('#propietarioFecha').val('');
		$('#propietarioLugarNac').val('');
		$('#propietarioEntid').val('');
		$('#propietarioPais').val('');
		$('#tdPropOtroDet').hide();
	}
	
	
	function limpiaPerPolExpSI(){
		$('#cargoPubPEPDet').val('');
		$('#periodo1PEP').val('');
		$('#periodo2PEP').val('');
		$('#ingresosMenPEP').val('');
		$('#nombreCompletoPEP').val('');
		$('#nivelFederalPEP').attr('checked',false);
		$('#nivelEstatalPEP').attr('checked',false);
		$('#nivelMunicipalPEP').attr('checked',false);
		
		$('#famEnCargoPEPSi').attr('checked',false);
		$('#famEnCargoPEPNo').attr('checked',false);
		$('#parentescoPEPMad').attr('checked',false);
		$('#parentescoPEPPad').attr('checked',false);
		$('#parentescoPEPHij').attr('checked',false);
		
	};
	
	function limpiaPolExpFam(){
		$('#cargoPubPEPDetFam').val('');
		$('#periodo1PEPFam').val('');
		$('#periodo2PEPFam').val('');
		$('#nombreCtoPEPFam').val('');
		$('#nombreRelacionPEP').val('');
		$('#parentescoPEPDet').val('');
		
		$('#nivelFederalPEPF').attr('checked',false);
		$('#nivelEstatalPEPF').attr('checked',false);
		$('#nivelMunicipalPEPF').attr('checked',false);
		$('#parentescoPEPFMad').attr('checked',false);
		$('#parentescoPEPFPad').attr('checked',false);
		$('#parentescoPEPFOtr').attr('checked',false);
		$('#relacionPEPSi').attr('checked',false);
		$('#relacionPEPNo').attr('checked',false);
	}
	
	function limpiaCuestPrincipal(){
		$('#realizadoOpNO').attr('checked',true);
		$('#actAltoRiesgo').attr('checked',true);
		$('#fuenteApoyoGuber').attr('checked',false);
		$('#observacionesEjec').val('');
		$('#otroAplDetalle').hide();
	}
	
	function inicializaPantalla(){
		$('#fuenteComer').attr('checked',false);
		$('#fuenteNuevaAct').attr('checked',false);
		$('#fuenteProvRecur').attr('checked',false);
		$('#fuenteOtra').attr('checked',false);
		$('#fuenteApoyoGuber').attr('checked',false);
		
		$('#incrementoVentas').attr('checked',false);
		$('#negocioNuevoTipo').attr('checked',false);
		
		$('#tipoApertNuev').attr('checked',false);
		$('#tipoFamiliarExt').attr('checked',false);
		$('#tipoCambioTrab').attr('checked',false);
		$('#tipoOtroNuevo').attr('checked',false);
		$('#cargoPubPEPNo').attr('checked',false);
		
		$('#proveedPFisica').attr('checked',false);
		$('#proveedPMoral').attr('checked',false);
		$('#ingresoAdiciNo').attr('checked',false);
		$('#proveedRecursosP').attr('checked',false);
		
		$('#fuenteApoyoGuber').attr('checked',false);
		$('#fuenteComer').attr('checked',false);
		$('#fuenteNuevaAct').attr('checked',false);
		$('#fuenteProvRecur').attr('checked',false);
		$('#fuenteOtra').attr('checked',false);
		$('#ingresoAdiciSi').attr('checked',false);
		
		$('#cargoPubPEPSi').attr('checked',false);
		$('#cargoPubPEPSO').attr('checked',false);
		$('#cargoPubPEPFa').attr('checked',false);
		
		$('#nivelFederalPEPF').attr('checked',false);
		$('#nivelEstatalPEPF').attr('checked',false);
		$('#nivelMunicipalPEPF').attr('checked',false);
		
		$('#parentescoPEPFPad').attr('checked',false);
		$('#parentescoPEPFMad').attr('checked',false);
		$('#parentescoPEPFHij').attr('checked',false);
		$('#parentescoPEPFOtr').attr('checked',false);
		$('#relacionPEPSi').attr('checked',false);
		$('#relacionPEPNo').attr('checked',false);		
		$('#fuenteOtraDet').val('');
		
	
		limpiaFisicaCAcA();
		limpiaFisicaCAcB();
		limpiaFisicaSAcB();
		limpiaFisicaSAcC();
		limpiaProveedRecA();
		limpiaProveedRecB();
		limpiaOtrosServi();
		limpiaPropReal();
		limpiaPerPolExpSI();
		limpiaPolExpFam();
		
		// Divs de Personas Fisicas Con Actividad Empresarial
		$('#divIncrementoVentas').hide();
		$('#divNuevoTipoNeg').hide();
		
		// Divs de Personas Fisicas Sin Actividad Empresarial
		$('#divFamiliarExt').hide();
		$('#divCambioTrabajo').hide();
		
		// Divs de Personas Politicamente Expuestas		
		$('#divApartadoAPEP').hide();
		$('#divApartadoBPEP').hide();
		
		// Divs Otros Servicios
		$('#divOtrosServiciosSI').hide();
		
		$('#divOtrosServicios').hide();
		$('#divPersonasPEPS').hide();
		$('#divPropietarioReal').hide();
		$('#divProveedoresRec').hide();
		$('#divPersonasSinAct').hide();
		$('#divPersonasFisicEmp').hide();
		$('#divFuenteRecursos').hide();
	}
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}
	
	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);



		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
	
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	//Regresar el foco a un campo de texto.
	function regresarFoco(idControl){
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus();
		 },0);
	}
	
	function validaActEmpresarial(event){
		if(($('#incrementoVentas').attr('checked') == false) &&
		($('#negocioNuevoTipo').attr('checked') == false ) &&
		($('#tipoApertNuev').attr('checked') == false ) 	&&
		($('#tipoFamiliarExt').attr('checked') == false )  &&
		($('#tipoCambioTrab').attr('checked') == false ) &&
		($('#tipoOtroNuevo').attr('checked') == false)  &&
		($('#fuenteComer').attr('checked') == true)   ){
			procede ='N';
			mensajeSis("Proceda a Contestar el Apartado de Personas Físicas con o sin Actividad Empresarial.");
			return procede;
		}else{
			procede= 'S';
			return procede;
		}
		
	}
	
	
	 
});

function exito(){
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('imprimir','submit');	
	inicializaForma('formaGenerica', 'clienteID');
	$('#fuenteOtra').attr('checked',false);
}