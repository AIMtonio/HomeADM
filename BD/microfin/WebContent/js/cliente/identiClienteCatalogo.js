
$(document).ready(function() {
	esTab = true;
	$('#clienteID').focus();
	var selectTipoIdentiID =null; 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionIdenCliente = {
			'agrega':'1',
			'modifica':'2',
			'elimina':'3'	};

	var catTipoConsultaIdenCliente = {
			'principal'	: 1,
			'foranea'	: 2,
			'comboBox' 	: 3,
			'tieneTipoIden' : 4
	};	
	var oficial = "SI";

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	llenaComboTiposIdenti();
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
	
	if($('#flujoCliNumCli').val() != undefined){
		if(!isNaN($('#flujoCliNumCli').val())){
			var numCliFlu = Number($('#flujoCliNumCli').val());
			$('#clienteID').val($('#flujoCliNumCli').val());
			consultaCliente('clienteID');
			if(numCliFlu > 0){
				if($('#flujoCliIdeID').val() != undefined){
					if(!isNaN($('#flujoCliIdeID').val())){
						var idenFlu = Number($('#flujoCliIdeID').val());
						if(idenFlu > 0){
							$('#identificID').val($('#flujoCliIdeID').val());
							validaIdenCliente('identificID');
						}else{
							$('#identificID').val();
						}
					}
				}
			}else{
				mensajeSis('No se puede Agregar Identificación Oficial sin Cliente');
			}
		}
	}

	$(':text').focus(function() {	
		esTab = false;
	});	
	
	$("#fecVenIden").change(function(){
		this.focus();
	});
	
	$("#fecExIden").change(function(){
		this.focus();
	});


	$.validator.setDefaults({
		submitHandler: function(event) {

			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','identificID'); 
		
					$('#tipoIdentiID').val('').selected = true;
					$('#oficial').val('');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('elimina', 'submit');
					if($('#flujoCliNumCli').val() != undefined){
						$('#flujoCliIdeID').val($('#identificID').val());
					}
		
		}
	});				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$('#agrega').click(function() {		
		
		var tipoIdenti = $('#tipoIdentiID').val(); 
        var numIdenti = $('#numIdentific').val();
		$('#tipoTransaccion').val(catTipoTransaccionIdenCliente.agrega);
	
	});

	$('#modifica').click(function() {	
				
		$('#tipoTransaccion').val(catTipoTransaccionIdenCliente.modifica);

		
	});	

	$('#elimina').click(function() {	
			
		$('#tipoTransaccion').val(catTipoTransaccionIdenCliente.elimina);
	
	
	});

	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<2){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '20', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if (cliente > 0) {
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			if (listaPersBloqBean.estaBloqueado != 'S') {
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if (expedienteBean.tiempo <= 1) {
					if (alertaCte(cliente) != 999) {
						consultaCliente(this.id);
					}
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					limpiaPantallaIdenti();
					$('#clienteID').focus();
					$('#clienteID').val('');
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				limpiaPantallaIdenti();
				$('#clienteID').focus();
				$('#clienteID').val('');
			}
		}
	});

	$('#identificID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "clienteID";
		camposLista[1] = "descripcion";


		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = $('#identificID').val();

		lista('identificID', '1', '1', camposLista, parametrosLista,'listaIdentificaciones.htm');
	});	


	

	function llenaComboTiposIdenti(){

		dwr.util.removeAllOptions('tipoIdentiID'); 
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiID'	,{'':'SELECCIONAR'});
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});		

	}

	$('#identificID').blur(function() {	
		validaIdenCliente(this);
	
	});



	$('#tipoIdentiID').change(function() {
		var numIden = $('#tipoIdentiID option:selected').val();
		
		if(numIden != ''){
			consultaIdentificacion('identificID');
		}
		else{
			mensajeSis("No Existe la Identificación del Cliente");
			deshabilitaBoton('agrega', 'submit');		
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
			$('#identificID').val('0');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
			$('#oficial').val('');
		}
	});


	$('#fecExIden').change(function() {
		var parametroBean = consultaParametrosSession();
		var Zfecha=  parametroBean.fechaSucursal;
		
		var Xfecha= $('#fecExIden').val();
		var Yfecha= $('#fecVenIden').val();
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fecExIden').val('');
			}
		}else{
			if ( mayor(Xfecha, Zfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy.")	;
				$('#fecExIden').val('');
			
			}
		}
	});

	$('#fecVenIden').change(function() {
		var Xfecha= $('#fecExIden').val();
		var Yfecha= $('#fecVenIden').val();
		var Zfecha=  parametroBean.fechaSucursal;
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fecVenIden').val('');
			}else if(mayor(Zfecha, Yfecha)){
				mensajeSis("La Fecha de Vencimiento debe ser Mayor a la Fecha del Sistema.")	;
				$('#fecVenIden').val('');
				
			}
		}else{
			mensajeSis("La Fecha de Vencimiento debe ser Mayor a la Fecha del Sistema.")	;
			$('#fecVenIden').val('');
		}
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {

			clienteID: {
				required: true,
				minlength: 1
			
			},

			tipoIdentiID: {
				required: true,
				minlength: 1
			},	

			numIdentific:{
				  required: true,
				  minlength:function(){
						var tipoIdenti = $('#tipoIdentiID').val();
						var numc = 5;
 					if(tipoIdenti==1){
						var elec= $('#numeroCaracteres').val();
							return elec;
						}if(tipoIdenti==2){
							var pasa= $('#numeroCaracteres').val();
							return pasa;
						}if(tipoIdenti>2){
							return numc;
						}
				  } ,
				  maxlength:function(){
						var tipoIdenti = $('#tipoIdentiID').val(); 
						var numc=15;
						if(tipoIdenti==1){
							var elec= $('#numeroCaracteres').val();
							return elec;
						}if(tipoIdenti==2){
							var pasa= $('#numeroCaracteres').val();
							return pasa;
						}if(tipoIdenti>2){
							return numc;
								}
				  			}  
					  
						},
					fecExIden: {
						date : true
					},
		
					fecVenIden: {
						required: true,
						date : true
					}
			},
			
		messages: {
			clienteID: {
				required: 'Especificar Cliente',
				minlength: 'Al menos 1 Caracter'
				
			},

			tipoIdentiID: {
				required: 'Seleccione un tipo de identificación', 
				minlength: 'Seleccione un tipo de identificación'
			},

			numIdentific:{
				  required: 'Especifique Folio de Identificación',
				  minlength:jQuery.format("Se Requieren Mínimo {0} Caracteres"),
				  maxlength:jQuery.format("Se Requieren Máximo {0} Caracteres"),
				} , 

			fecExIden: {
				date : 'Fecha Incorrecta'
			},

			fecVenIden: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			}
		}		
	});

	//------------ Validaciones de Controles -------------------------------------

	function validaIdenCliente(control) {
		var numIdentificacion = $('#identificID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var ofi ='S';
	
		if(numIdentificacion != '' && !isNaN(numIdentificacion)  ){

			if(numIdentificacion=='0'){
				consultaCliente('clienteID');	
				if( $('#clienteID').val()!='') {
					habilitaBoton('agrega', 'submit');		
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('elimina', 'submit');
					$('#tipoIdentiID').val('').selected = true;
				}
				else{					
					deshabilitaBoton('agrega', 'submit');		
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('elimina', 'submit');
				}
					$('#numIdentific').val('');
					$('#fecExIden').val('');
					$('#fecVenIden').val('');
					$('#oficial').val('');

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				habilitaBoton('elimina', 'submit');				
				var identifiCliente = {
						'clienteID' :  $('#clienteID').val(),
						'identificID' : $('#identificID').val()
				};

				identifiClienteServicio.consulta(catTipoConsultaIdenCliente.principal,identifiCliente,function(identificacion) {
					if(identificacion!=null){
						dwr.util.setValues(identificacion);	
						$('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
						selectTipoIdentiID = $('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
						consultaTipoIdent(selectTipoIdentiID);
						if($('#fecExIden').val()=='1900-01-01' ){							
							$('#fecExIden').val('');												
						}
						 if($('#fecVenIden').val()=='1900-01-01'){
							$('#fecVenIden').val('');
					
						}

						 $('#oficial').val(identificacion.oficial);	
						
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('elimina', 'submit');
						habilitaBoton('modifica', 'submit');	
						if ($('#estatus').val()=='I'){
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('agrega','submit');
							deshabilitaBoton('elimina','submit');
						}
					}else{

						mensajeSis("No Existe la Identificación del Cliente.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('elimina', 'submit');
						$('#identificID').val('0');
						validaIdenCliente('identificID');


					}
				});
				
			}
		
		}
		if(numIdentificacion != '' && isNaN(numIdentificacion) && esTab ){
			mensajeSis("No Existe la Identificación del Cliente");
			$('#tipoIdentiID').val('');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
			$('#oficial').val('');
			$('#identificID').val('');
		}
	}

function limpiaPantallaIdenti(){
	$('#nombreCliente').val('');
	$('#tipoIdentiID').val('');
	$('#numIdentific').val('');
	$('#fecExIden').val('');
	$('#fecVenIden').val('');
	$('#oficial').val('');
	$('#identificID').val('');
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('elimina','submit');
}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 1;
		var clienteBeanCon = {
				'clienteID'	:numCliente
			};
		setTimeout("$('#cajaLista').hide();", 200);		

		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);							
					$('#nombreCliente').val(cliente.nombreCompleto);
					
					  if (cliente.estatus=="I"){
						  $('#estatus').val(cliente.estatus);
							mensajeSis("El Cliente se Encuentra Inactivo.");
							 limpiaPantallaIdenti();
							$(jqCliente).focus();
							$(jqCliente).select();
						}else{
							$('#estatus').val('');
							if(cliente.edad < 18){	
								mensajeSis("El Cliente es Menor de Edad.");
								limpiaPantallaIdenti();
								$(jqCliente).focus();
								$(jqCliente).select();
							}
						}				    
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					limpiaPantallaIdenti();
					$(jqCliente).focus();
				}    	 						
			});
		}else{
			$('#nombreCliente').val('');
		}
		if(numCliente != '' && isNaN(numCliente) && esTab ){
			mensajeSis("No Existe el Cliente");
			$('#clienteID').val('');
			$('#tipoIdentiID').val('');
			$('#nombreCliente').val('');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
			$('#oficial').val('');
			$('#identificID').val('');
			$('#clienteID').focus();
			$('#clienteID').select();
			
		}
	}	

	function consultaIdentificacion(idControl) {
		var numIden = $('#tipoIdentiID option:selected').val(); 
		var conIde = 4;

		setTimeout("$('#cajaLista').hide();", 200);		
		if(numIden != '' && !isNaN(numIden)  ){
			var identifiCliente = {
					'clienteID' :  $('#clienteID').val(),
					'tipoIdentiID' : numIden
			};

			identifiClienteServicio.consulta(conIde,identifiCliente,function(identificacion) {
				if(identificacion!=null){
					if(identificacion.tipoIdentiID == numIden){
						habilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('elimina', 'submit');
						$('#identificID').val(identificacion.identificID);   							  		
						validaIdenCliente('identificID');	
						consultaTipoIdent(numIden);
						if ($('#estatus').val()=='I'){
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('agrega','submit');
							deshabilitaBoton('elimina','submit');
						}
					}
					
				}else{
					consultaTipoIdent(numIden);
					$('#identificID').val('0');
					$('#numIdentific').val('');
					$('#fecExIden').val('');
					$('#fecVenIden').val('');

					habilitaBoton('agrega', 'submit');		
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('elimina', 'submit');
					if ($('#estatus').val()=='I'){
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('agrega','submit');
						deshabilitaBoton('elimina','submit');
					}
				}    	 						
			});
		}
	}	

	function consultaTipoIdent(numIdentific) {
		var tipConP = 1;	
		
		var numTipoIden = $('#tipoIdentiID option:selected').val();
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numIdentific != '' && !isNaN(numIdentific)  ){

			tiposIdentiServicio.consulta(tipConP,numTipoIden,function(identificacion) {
				if(identificacion!=null){							
					$('#tipoIdentiID').val(identificacion.tipoIdentiID);
					$('#numeroCaracteres').val(identificacion.numeroCaracteres);
					$('#oficial').val(identificacion.oficial);



				}else{
					mensajeSis("No Existe la Identificación");
				}    	 						
			});
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
	
	

});
