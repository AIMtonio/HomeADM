$(document).ready(function() {
		esTab = true;
		$('#clienteID').focus();
	//Definicion de Constantes y Enums  
	var catTipoTransaccionEscritura = {  
  		'agrega':'1',
  		'modifica':'2' };	
	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
	
	if($('#flujoCliNumCli').val() != undefined){
		if(!isNaN($('#flujoCliNumCli').val())){
			var numCliFlu = Number($('#flujoCliNumCli').val());
			if(numCliFlu > 0){
				$('#clienteID').val($('#flujoCliNumCli').val());
				consultaCliente('clienteID');
				
			}else{
				mensajeSis('No se puede agregar Escritura sin Cliente');
			}
		}
	}

	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
          	  submitHandler: function(event) {
        			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','consecutivoEsc','exitoTransEscritura','');
            
          	  }
    });
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$('#fechaEsc').change(function() {
		var Xfecha= $('#fechaEsc').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaEsc').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
				$('#fechaEsc').val(parametroBean.fechaSucursal);
			}else{
				$('#fechaEsc').focus();	
			}
		}else{
			$('#fechaEsc').val(parametroBean.fechaSucursal);
		}

	});
	
	$('#fechaRegPub').change(function() {
		var Xfecha= $('#fechaRegPub').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegPub').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
				$('#fechaRegPub').val(parametroBean.fechaSucursal);
			}else{
				$('#fechaRegPub').focus();	
			}
		}else{
			$('#fechaRegPub').val(parametroBean.fechaSucursal);
		}

	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionEscritura.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionEscritura.modifica);
	});	
	$('#fechaEsc').blur(function() {
  		$('#estadoIDEsc').focus();
	});
	$('#fechaRegPub').blur(function() {
  		$('#estadoIDReg').focus();
	});

	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});
	
	$('#consecutivoEsc').bind('keyup',function(e){ 
			var camposLista = new Array();
			var parametrosLista = new Array();
		
			camposLista[0] = "clienteID";
			camposLista[1] = "esc_Tipo";
			
		
			parametrosLista[0] = $('#clienteID').val();
			parametrosLista[1] = $('#consecutivoEsc').val();
			
		
		lista('consecutivoEsc', '0', '1', camposLista,parametrosLista, 'listaEscrituraPub.htm');  
	});
	
	$('#consecutivoEsc').blur(function() {
  		validaEscrituraPub(this);
  	});
  	
	
	$('#estadoIDEsc').bind('keyup',function(e){
		lista('estadoIDEsc', '2', '1', 'nombre', $('#estadoIDEsc').val(), 'listaEstados.htm');
	});
	
	$('#estadoIDEsc').blur(function() {
  		consultaEstadoEsc(this.id);
	});
	
	$('#localidadEsc').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDEsc').val();
		parametrosLista[1] = $('#localidadEsc').val();
		
		lista('localidadEsc', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#localidadEsc').blur(function() {
  		consultaMunicipioEsc(this.id);
	});
	
	$('#estadoIDReg').bind('keyup',function(e){
		lista('estadoIDReg', '2', '1', 'nombre', $('#estadoIDReg').val(), 'listaEstados.htm');
	});
	
	$('#estadoIDReg').blur(function() {
  		consultaEstadoReg(this.id);
	});
	
	$('#localidadRegPub').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDReg').val();
		parametrosLista[1] = $('#localidadRegPub').val();
		
		lista('localidadRegPub', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#localidadRegPub').blur(function() {
  		consultaMunicipioReg(this.id);
	});
	
	$('#notaria').bind('keyup',function(e){ 
		//TODO Agregar Libreria de Constantes Tipo Enum
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "municipioID";
		camposLista[2] = "titular"; 
		
		parametrosLista[0] = $('#estadoIDEsc').val();
		parametrosLista[1] = $('#localidadEsc').val();
		parametrosLista[2] = $('#notaria').val();
		
		if($('#estadoIDEsc').val() != '' && $('#estadoIDEsc').asNumber() > 0 ){
			if($('#localidadEsc').val()!='' && $('#localidadEsc').asNumber()>0){
				lista('notaria', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
			}else{
				if($('#notaria').val().length >= 3){
					$('#localidadEsc').focus();
					$('#notaria').val('');
					$('#nomNotario').val('');
					mensajeSis('Especificar Localidad');
				}
			}
		}else{
			if($('#notaria').val().length >= 3){
				$('#estadoIDEsc').focus();
				$('#notaria').val('');
				$('#nomNotario').val('');
				mensajeSis('Especificar Entidad Federativa');
			}

		}		

	});
		 
	$('#notaria').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#notaria').val() 	!= 	'' &&	$('#notaria').val() > 0	&&	!isNaN($('#notaria').val())){
			if($('#estadoIDEsc').val()!=''  ){
				if($('#localidadEsc').val() !=''){
					consultaNotaria(this.id);
				}else{
					$('#nomNotario').val('');
					$('#notaria').val('');
					mensajeSis("Elija una Localidad  antes de buscar Notaria");
				}
			}else{
				$('#nomNotario').val('');
				$('#notaria').val('');
				mensajeSis("Elija una Entidad Federativa  antes de buscar Notaria");
			}
		}else{
			$('#nomNotario').val('');
			$('#notaria').val('');
		}
  
	});
	
	$('#esc_Tipo').blur(function() {	 
		var tipActa = $('#esc_Tipo').val();
		if(tipActa == 'P'){
		$('#apoderados').show(500);
		}else{
		$('#apoderados').hide(500);
		}
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			clienteID: {
				required: true,
				minlength: 1
			},
			consecutivoEsc: {
				required: false,
				minlength: 1
			},
			esc_Tipo: {  
				required: true,
				minlength: 1
			},
			escrituraPub: {  
				required: true,
				minlength: 3,
				maxlength: 50
			},		
			libroEscritura: {
				
				maxlength: 50
			},
			volumenEsc:{
				
				maxlength: 10
			},
			
			fechaEsc: {  
				required: true,
				minlength: 5
			},	
			estadoIDEsc: {
				required: true,
				minlength: 1,
				number:true
			},	
			localidadEsc: { 
				required: true,
				minlength: 1,
				number:true
			},	
			notaria: {
			required: true,
			minlength: 1
			
			},	
			
			registroPub: {
			required: true,
			maxlength: 10
			
			},
			folioRegPub: {
			required: true,
			maxlength: 10
			},
			volumenRegPub: {
			maxlength: 10
			},
			libroRegPub: {
			
			maxlength: 10
			}, 
			auxiliarRegPub: {
			
			maxlength: 20
			},
			fechaRegPub: {
			required: true
			
			},
			estadoIDReg: {
			required: true,
			number:true
			},
			localidadRegPub: {
			required: true,
			number:true
			}
			
		},
		messages: {
			
		
				clienteID: {
				required: 'Especificar Cliente',
				minlength: 'Al menos 5 Caracteres'
			},
			
			
			esc_Tipo: {
				required: 'Especificar tipo de Escritura '
			},
			escrituraPub: {
				required: 'Especificar Escritura', 
				minlength: 'Al menos 5 Caracteres',
			    maxlength: 'Máximo 50 Caracteres'
			},
			
			libroEscritura: {
				required: 'Especificar Libro', 
			    maxlength: 'Máximo 50 Caracteres'
			},
			volumenEsc: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
			},
			
			fechaEsc: {
				required: 'Especificar Fecha', 
				minlength: 'Al menos 8 Caracteres'
			},
			estadoIDEsc: {
				required: 'Especificar Estado', 
				minlength: 'Al menos 2 Caracteres',
				number:'Sólo Números'
			},
			localidadEsc: {
				required: 'Especificar Localidad.', 
				minlength: 'Al menos 2 Caracteres',
				number:'Sólo Números'
			},
			notaria: {
				required: 'Especificar Notaria.', 
				minlength: 'Al menos 1 Caracteres'
				
			},
			
			registroPub: {
			required: 'Especificar Registro Publico.',
			maxlength: 'Máximo 10 Caracteres'
				
			},
			folioRegPub: {
			required: 'Especificar Folio.',
			maxlength: 'Máximo 10 Caracteres'
			
			},
			volumenRegPub: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
			},
			libroRegPub: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
				}, 
				auxiliarRegPub:{
				required: 'Especificar Volumen', 
				maxlength: 'Máximo 20 Caracteres'
				},
			fechaRegPub: {
			required: 'Especificar Fecha.'
			
			},
			estadoIDReg: {
			required: 'Especificar Entidad.',
			number:'Sólo Números'
			
			},
			localidadRegPub: {
			required: 'Especificar Localidad.',
			number:'Sólo Números'
			
			}
		
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaEscrituraPub(control) {
		var numEscri = $('#consecutivoEsc').val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numEscri != '' && !isNaN(numEscri) && esTab){
			
			if(numEscri=='0'){
				//consultaCliente($('#clienteID').val());
				consultaCliente('clienteID');				
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','clienteID');
				
				
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var EscrituraBeanCon = {
  				'clienteID':$('#clienteID').val(),
  				'consecutivo':$('#consecutivoEsc').val()
				};
				escrituraServicio.consulta(1,EscrituraBeanCon,function(escritura) {
						if(escritura!=null){
							dwr.util.setValues(escritura);
							$('#nombreEstadoEsc').val(escritura.estadoIDEsc);
								consultaEstadoEsc('nombreEstadoEsc');
							$('#nombreMuniEsc').val(escritura.localidadEsc);
								consultaMunicipioEsc('nombreMuniEsc');
								$('#nombreEstadoReg').val(escritura.estadoIDReg);
								consultaEstadoReg('nombreEstadoReg');
							$('#nombreMuniReg').val(escritura.localidadRegPub);
								consultaMunicipioReg('nombreMuniReg');
								var tipActa = escritura.esc_Tipo; 
								if(tipActa == 'P'){
								$('#apoderados').show(500);
								}else{
								$('#apoderados').hide(500);
								}
								var es = escritura.estatus; 
								if(es == 'V'){
								$('#estatusV').attr("checked",1);
								}else{
								$('#estatusV').attr("checked",false); 
								}
								if(es == 'R'){
								$('#estatusR').attr("checked",1);
								}else{
								$('#estatusR').attr("checked",false); 
								}
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
											
						}else{
							
							mensajeSis("No Existe la Escritura Pública");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
   						
								$('#consecutivoEsc').focus();
								$('#consecutivoEsc').select();	
																			
							}
				});
						
			}
												
		}
	}
	
		function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){	
							$('#clienteID').val(cliente.numero);				
							$('#nombreCliente').val(cliente.nombreCompleto);															
						}else{
							mensajeSis("No Existe el Cliente");
							$('#clienteID').focus();
							$('#clienteID').select();	
							inicializaForma('formaGenerica','clienteID');
						
						}    	 						
				});
			}
		}	
	
		function consultaEstadoEsc(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){							
							$('#nombreEstadoEsc').val(estado.nombre);
																	
						}else{
							mensajeSis("No Existe el Estado");
							$('#estadoIDEsc').focus();
							$('#estadoIDEsc').select();
							$('#estadoIDEsc').val("");
							$('#nombreEstadoEsc').val("");
							$('#localidadEsc').val("");
							$('#nombreMuniEsc').val("");
						}    	 						
				});
			}else{if(isNaN(numEstado) && esTab)
				{
				mensajeSis("No existe el Estado");
				$('#estadoIDEsc').focus();
				$('#estadoIDEsc').select();
				$('#estadoIDEsc').val("");
				$('#nombreEstadoEsc').val("");
				$('#localidadEsc').val("");
				$('#nombreMuniEsc').val("");
				}
			}
		}	
	
		function consultaMunicipioEsc(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoIDEsc').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuniEsc').val(municipio.nombre);						
						}else{
							mensajeSis("No Existe el Municipio");
								$('#localidadEsc').focus();
								$('#localidadEsc').select();
								$('#localidadEsc').val("");
								$('#nombreMuniEsc').val("");
						}    	 						
				});
			}else{ 
				if(isNaN(numMunicipio) && esTab){
					mensajeSis("No Existe el Municipio");
					$('#localidadEsc').focus();
					$('#localidadEsc').select();
					$('#localidadEsc').val("");
					$('#nombreMuniEsc').val("");
				}
				
			}
		}	
		
	
		function consultaEstadoReg(idControl) {
			var jqEstado = eval("'#" + idControl + "'");
			var numEstado = $(jqEstado).val();	
			var tipConForanea = 2;	
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numEstado != '' && !isNaN(numEstado) && esTab){
				estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
							if(estado!=null){							
								$('#nombreEstadoReg').val(estado.nombre);
																		
							}else{
								mensajeSis("No Existe el Estado");
								$('#estadoIDReg').focus();
								$('#estadoIDReg').select();
								$('#estadoIDReg').val("");
								$('#nombreEstadoReg').val("");
								$('#localidadRegPub').val("");
								$('#nombreMuniReg').val("");
							}    	 						
					});
				}else{
					if(isNaN(numEstado) && esTab){
						mensajeSis("No Existe el Estado");
						$('#estadoIDReg').focus();
						$('#estadoIDReg').select();
						$('#estadoIDReg').val("");
						$('#nombreEstadoReg').val("");
						$('#localidadRegPub').val("");
						$('#nombreMuniReg').val("");
					}
				}
			}	
	
		function consultaMunicipioReg(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoIDReg').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuniReg').val(municipio.nombre);						
						}else{
							mensajeSis("No Existe el Municipio");
								$('#localidadRegPub').focus();
								$('#localidadRegPub').select();
								$('#localidadRegPub').val("");
								$('#nombreMuniReg').val("");
						}    	 						
				});
			}
		else{
			if(isNaN(numMunicipio) && esTab){
				mensajeSis("No Existe el Municipio");
				$('#localidadRegPub').focus();
				$('#localidadRegPub').select();
				$('#localidadRegPub').val("");
				$('#nombreMuniReg').val("");
			}
		}
		}		

 
		function consultaNotaria(idControl) { 
				var jqNotaria = eval("'#" + idControl + "'");
				var numNotaria = $(jqNotaria).val();	
				
				var notariaBeanCon = {
		  				'estadoID':$('#estadoIDEsc').val(),
		  				'municipioID':$('#localidadEsc').val(),
		  				'notariaID':numNotaria
						};
						
						var tipConForanea = 2;	
						setTimeout("$('#cajaLista').hide();", 200);	
					if(numNotaria != '' && !isNaN(numNotaria) && esTab){
						 
							notariaServicio.consulta(tipConForanea,notariaBeanCon,function(notaria) {
									if(notaria!=null){	
										$('#notaria').val(notaria.notariaID);	
										$('#direcNotaria').val(notaria.direccion);
										$('#nomNotario').val(notaria.titular);					
									}else{ 
										mensajeSis("No Existe La Notaria");
											$('#notaria').focus();
											$('#notaria').select();	
											$('#notaria').val("");
											$('#direcNotaria').val("");
											$('#nomNotario').val("");
									}
							});
				}
			}						
	 
		
});
	

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
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
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea.");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return false;
		}
		return true;
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


function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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


	function exitoTransEscritura(){
		
		$('#esc_Tipo').val('');
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		inicializaForma('formaGenerica','consecutivoEsc');
		
	}