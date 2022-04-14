// este js se utiliza para agregar beneficiarios en la pantalla de  apertura de inversiones y reinversiones
var BeneficiariosCuenta = 'S';// Beneficiarios propios de la Cuenta
var esMenorEdad			= ''; // si el cliente beneficiario es menor de edad
var fecha_vacia			= '1900-01-01';	// constante para fecha vacia

var confirmar = false;
$(document).ready(function() {
	esTab = true;


	// deficion de constantes y enums
	var catTipoTransaccionInverPer = {
	  		'guardarBen'	:1,
	  		'modificaBen'	:2,	
	  		'eliminaBen'	:3,
	  		'heredarBen'	:4
	};

	var catTipoConsultaDirCliente = {
	  		'principal'	:	1,
	  		'foranea'	:	2,
			'oficialDirec' :  3,
			'oficial'  : 4,
			'verOficial' : 5
		};
	
	
//	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('modificarBen','submit');  
	deshabilitaBoton('guardarBen', 'submit');
	deshabilitaBoton('eliminarBen','submit');
	agregaFormatoControles('formaGenerica2');
	consultaTipoIden();
	
	$.validator.setDefaults({
		submitHandler: function(event) {	
				if (confirmar == true) {
			
					if($('#tipoTransaccion1').val() !=''){
						habilitaCombos();
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','beneInverID','exitoBen','error');

				}
			}
		}
	
	});
	
	$('#heredarBen').click(function(){		
		$('#tipoTransaccion1').val(catTipoTransaccionInverPer.heredarBen);		
		confirmar=confirm("Al Heredar los Beneficiarios de la Última Inversión se Eliminarán los Beneficiarios Actuales");
		if(confirmar == true){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','beneInverID','exitoBen','error');
			}
				
	});

		
	$('#guardarBen').click(function() {		
		if($('#beneficiarioInver').is(':checked')){
			$("#beneficiarioBen").val('I');
		}else{
				$("#beneficiarioBen").val('S');
			}
			$('#tipoTransaccion1').val(catTipoTransaccionInverPer.guardarBen);
		confirmar = true;
	});
	
	$('#modificarBen').click(function() {		
		$('#tipoTransaccion1').val(catTipoTransaccionInverPer.modificaBen);
		confirmar = true;
	});
	
	$('#eliminarBen').click(function(){		
		$('#tipoTransaccion1').val(catTipoTransaccionInverPer.eliminaBen);
		confirmar = true;		

	});
		
	$('#fechaNacimiento').change(function(){	
		$('#fechaNacimiento').focus();
		
	});
	$('#fechaNacimiento').blur(function(){
		calculaEdad($('#fechaNacimiento').val());
	});
	$('#fecVenIden').change(function(){	
		$('#fecVenIden').focus();
	});
	$('#fecExIden').change(function(){	
		$('#fecExIden').focus();
	
		if($('#fecExIden').val()> parametroBean.fechaAplicacion){
			mensajeSis('La Fecha Capturada es Mayor a la del Sistema.');
			$('#fecExIden').val('');
			$('#fecExIden').focus();
		}
	});
	
//	Búsqueda de beneficiario
	$('#beneInverID').blur(function() {		
  		consultaBeneficiario($('#beneInverID').val());  		
	});

	$('#beneInverID').bind('keyup',function(e){		
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "inversionID";
		camposLista[1] = "nombreCompleto";
		
		parametrosLista[0] = $('#inversionID').val();
		parametrosLista[1] = $('#beneInverID').val();
				
		lista('beneInverID', '1', '1', camposLista, parametrosLista, 'listaBeneficiariosInver.htm');
	});

	$('#numeroCte').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('numeroCte', '2', '1', 'nombreCompleto', $('#numeroCte').val(), 'listaCliente.htm');
		}
	});
	
	$('#numeroCte').blur(function() {		
		// Se da de alta nuevo beneficiario que no es cliete
		if( $('#beneInverID').val()== 0 && $('#numeroCte').val() == 0 ){
			inicializaForma('personasRelacionadas','beneInverID');
			habilitaFormularioInversionPersona();
			habilitaCombos();
			habilitaBoton('guardarBen','submit');
			deshabilitaBoton('modificarBen','submit');
			deshabilitaBoton('eliminarBen','submit');
			habilitaBoton('generarc','submit');
			habilitaBoton('generar','submit');
			reiniciaCombos();
			consultaBeneficiariosGrid();		

		}
			consultaClienteBeneficiario($('#numeroCte').val());				
  	});
	
	$('#paisID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('paisID', '2', '1', 'nombre',
					$('#paisID').val(), 'listaPaises.htm');
		}
	}); 
	
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	
	});
	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
	});
	
	$('#ocupacionID').bind('keyup',function(e){
		
		lista('ocupacionID', '1', '1', 'descripcion',
				 $('#ocupacionID').val(), 'listaOcupaciones.htm');
	});	
	
	$('#ocupacionID').blur(function() {
  		consultaOcupacion(this.id);
	}); 
	
	// Tipo de Relación
	$('#parentescoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('parentescoID', '2', '1', 'descripcion',
					$('#parentescoID').val(), 'listaParentescos.htm');
		}
	}); 
	
	$('#parentescoID').blur(function() {
  		consultaParentescos($('#parentescoID').val(),'');
	}); 
		
	$('#paisID').blur(function() { 
  		consultaPais(this.id);
	});
	
	$('#edoNacimiento').blur(function() {
		consultaEstadoDatosP(this.id);
	});
	
	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val()!=''){
		formaCURP();
		$('#generarc').select();
		$('#curp').focus();
		}else{
		mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});	
	
	$('#generar').click(function() {
		if ($('#fechaNacimiento').val()!=''){
		formaRFC();		
		$('#rfc').select();
		$('#rfc').focus();
		}else{
		mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});
	
	$('#tipoIdentiID').change(function() {
		if(this.value !=''){
			consultaTipoIdent2(this.id, 'numIdentific');
		}		
	});
	
	$("#telefonoCelular").setMask('phone-us');
	$("#telefonoCasa").setMask('phone-us');
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica2').validate({
				
		rules	: {
						
			primerNombre	: {
				required	: true,
				minlength	: 3,
				
			},
			apellidoPaterno : 'required',
			
			sexo			:'required',
						
			curp	: {
				required	: true,
				maxlength	: 18
			},
			RFC	: {
				required	: true,
				maxlength	: 13
			},
			tipoIdentiID    :{
				required : function() {return esMenorEdad != 'S';}
			},
			numIdentific	: {
				  required: function() {return $('#tipoIdentiID').val() != '';}
 
				  
			},							 
			domicilio		: 'required',			
			parentescoID		: 'required', 	  				
			porcentaje 		: 'required',   
			
			correo : {
				required : false,
				email : true
			},
			fechaNacimiento : {
				required	: true,
				date: true
			},
			
			fecVenIden : {
				date: true
			},
			
			fecExIden : {
				date: true
			},
			
			paisID : {
				required	: true,
			},
			
			estadoID : {
				required	: true,
			},
		},
				
		messages: {
			
			primerNombre: {
				required	: 'Especifique Nombre',
				minlength	: 'Al menos 3 Caracteres',				
			},
		
			apellidoPaterno : 'Especifique Apellido Paterno',
			
			sexo			: 'Especifique sexo',
			
			curp	: {
				required	: 'Especifique CURP.',
				maxlength	: 'Máximo 18 caracteres.'
			},
			
			RFC	: {
				required	: 'Especifique RFC.',
				maxlength	: 'Máximo 13 caracteres.',
			},
			
			tipoIdentiID    : 'Especifique Identificación',
			 		
			numIdentific	: {

				required:"Campo requerido",

			  } , 
			domicilio		: 'Especifique Domicilio ', 
				parentescoID	:	{
					required		: function (){
						var mensaje = 'Se requiere el parentesco del beneficiario.';
						return mensaje;}
				},
			porcentaje	:	{
					required		: function (){
						var mensaje = 'Se requiere el porcentaje que se le asigna al beneficiario.';
						return mensaje;}
				},
			correo : {
					required : 'Especifique un Correo',
					email : 'Dirección Inválida'
				},
			fechaNacimiento : {
					required : 'Especifique Fecha de Nacimiento',
					date : 'Fecha Incorrecta'
				},
			fecVenIden : {
					date : 'Fecha Incorrecta'
				},
			fecExIden : {
					date: 'Fecha Incorrecta'
				},
				
				paisID : {
					required : 'Especifique País',
					
				},
				estadoID : {
					required : 'Especifique la Entidad Federativa',
					
				}
		}		
	});
	

	//-- Consulta de beneficiarios que son clientes y prepara formulario para guardar-- SOLO CLIENTES// 
	function consultaClienteBeneficiario(numCliente) {			
		var rfc = ' ';
			if(numCliente!='0' && esTab){
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(1,numCliente,rfc,function(cliente){
							if(cliente!=null){
								
								
								if(( $('#beneInverID').val() == 0 && $('#numeroCte').val())>0 ){	
					
									$('#numeroCte').val(cliente.numero);
									$('#nombreCompletoC').val(cliente.nombreCompleto);
									$('#titulo').val(cliente.titulo).selected = true;
									$('#primerNombre').val(cliente.primerNombre);
									$('#segundoNombre').val(cliente.segundoNombre);
									$('#tercerNombre').val(cliente.tercerNombre);
									$('#apellidoPaterno').val(cliente.apellidoPaterno);
									$('#apellidoMaterno').val(cliente.apellidoMaterno);
									$('#fechaNacimiento').val(cliente.fechaNacimiento);
									$('#estadoCivil').val(cliente.estadoCivil).selected = true;
									$('#sexo').val(cliente.sexo).selected = true;								
									$('#curp').val(cliente.CURP);
									$('#rfc').val(cliente.RFC);
									$('#clavePuestoID').val(cliente.puesto);
									$('#paisID').val(cliente.paisResidencia);
									$('#telefonoCasa').val(cliente.telefonoCasa);
									$('#telefonoCelular').val(cliente.telefonoCelular);
									$('#correo').val(cliente.correo);
									consultaPais('paisID');
									$('#estadoID').val(cliente.estadoID);
									consultaEstado('estadoID');
									$('#ocupacionID').val(cliente.ocupacionID);
									consultaOcupacion('ocupacionID');
									
									consultaDireccion('numeroCte');
								
									if(cliente.esMenorEdad != 'S'){
										consultaIdenCliente(cliente.numero);
									}
									
									deshabilitaFomInversion();
									
									deshabilitaBoton('modificarBen','submit');
									deshabilitaBoton('eliminarBen','submit');
									if($('#inversionIDBen').asNumber() >0){
										habilitaBoton('guardarBen','submit');		
									}
									$('#parentescoID').focus();	
								}else{
									if(( $('#beneInverID').val()> 0 ) ){ // consulta beneficiario sea o no sea cliente permite modificar o eliminar
//										if($('#numeroCte').val() >0){
											$('#parentescoID').focus();
//										}																			
										$('#nombreCompletoC').val('');
										$('#titulo').val(cliente.titulo).selected = true;
										$('#primerNombre').val(cliente.primerNombre);
										$('#segundoNombre').val(cliente.segundoNombre);
										$('#tercerNombre').val(cliente.tercerNombre);
										$('#apellidoPaterno').val(cliente.apellidoPaterno);
										$('#apellidoMaterno').val(cliente.apellidoMaterno);
										$('#fechaNacimiento').val(cliente.fechaNacimiento);
										$('#estadoCivil').val(cliente.estadoCivil).selected = true;
										$('#sexo').val(cliente.sexo).selected = true;								
										$('#curp').val(cliente.CURP);
										$('#rfc').val(cliente.RFC);
										$('#clavePuestoID').val(cliente.puesto);
										$('#paisID').val(cliente.paisResidencia);
										$('#telefonoCasa').val(cliente.telefonoCasa);
										$('#telefonoCelular').val(cliente.telefonoCelular);
										$('#correo').val(cliente.correo);
										$('#numeroCte').val(cliente.numero); // pone el numero del cliente
										$('#nombreCompletoC').val(cliente.nombreCompleto); // pone el nombre del cliente
										consultaPais('paisID');
										$('#estadoID').val(cliente.estadoID);
										consultaEstado('estadoID');
										$('#ocupacionID').val(cliente.ocupacionID);
										consultaOcupacion('ocupacionID');
										if(cliente.esMenorEdad != 'S'){
											consultaIdenCliente(cliente.numero);
										}
										consultaDireccionCliente(cliente.numero);
										deshabilitaFomInversion();
										deshabilitaBoton('guardarBen','submit');
										habilitaBoton('modificarBen','submit');
										habilitaBoton('eliminarBen','submit');
										
										}									
									
								}						
								
								esMenorEdad = cliente.esMenorEdad;
								
								if (cliente.estatus=="I"){
									deshabilitaBoton('guardarBen','submit');
									mensajeSis("El "+$('#socioCliente').val()+" se encuentra Inactivo");
								}	
								
								}else{							
									mensajeSis("El "+$('#socioCliente').val()+" No Existe.");
									$('#numeroCte').focus();
									$('#numeroCte').val('');
									$('#nombreCompletoC').val('');
								
							}    						
					});
				}
		}
	}
	
	//-- Consulta Principal de Beneficiarios  sin importar si es cliente o no --//
	function consultaBeneficiario(numBeneficiario) {	
			setTimeout("$('#cajaLista').hide();", 200);				
			var numConsulta=1;
			var beneficiariosIver = {
						'inversionIDBen':$('#inversionIDBen').val(),
						'beneInverID':numBeneficiario
				};
			if(numBeneficiario != '' && !isNaN(numBeneficiario) && numBeneficiario >0){
				beneficiariosInverServicio.consulta(numConsulta,beneficiariosIver,function(beneficiarioInver){
						if(beneficiarioInver!=null ){	
							
							
								$('#titulo').val(beneficiarioInver.titulo).selected = true;
								$('#primerNombre').val(beneficiarioInver.primerNombre);
								$('#segundoNombre').val(beneficiarioInver.segundoNombre);
								$('#tercerNombre').val(beneficiarioInver.tercerNombre);
								$('#apellidoPaterno').val(beneficiarioInver.apellidoPaterno);
								$('#apellidoMaterno').val(beneficiarioInver.apellidoMaterno);
								$('#fechaNacimiento').val(beneficiarioInver.fechaNacimiento);
								$('#estadoCivil').val(beneficiarioInver.estadoCivil).selected = true;
								$('#sexo').val(beneficiarioInver.sexo).selected = true;								
								$('#curp').val(beneficiarioInver.curp);
								$('#rfc').val(beneficiarioInver.rfc);
								$('#clavePuestoID').val(beneficiarioInver.puesto);
								$('#paisID').val(beneficiarioInver.paisID);
								$('#telefonoCasa').val(beneficiarioInver.telefonoCasa);
								$('#telefonoCelular').val(beneficiarioInver.telefonoCelular);
								$('#correo').val(beneficiarioInver.correo);
								$('#porcentaje').val(beneficiarioInver.porcentaje);
								$('#parentescoID').val(beneficiarioInver.parentescoID);								
								$('#estadoID').val(beneficiarioInver.estadoID);																						
								$('#ocupacionID').val(beneficiarioInver.ocupacionID);
								$('#domicilio').val(beneficiarioInver.domicilio);
								$('#clavePuestoID').val(beneficiarioInver.clavePuestoID);
								
																														
								if(beneficiarioInver.fecExIden != fecha_vacia){
									$('#fecExIden').val(beneficiarioInver.fecExIden);								
								}
								if(beneficiarioInver.fecExIden != fecha_vacia){
									$('#fecVenIden').val(beneficiarioInver.fecVenIden);									
								}
								
								$('#tipoIdentiID').val(beneficiarioInver.tipoIdentiID).selected = true;
								$('#numIdentific').val(beneficiarioInver.numIdentific);
								$('#numeroCte').val(beneficiarioInver.clienteID);
								$('#nombreCompletoC').val('');
								
								calculaEdad(beneficiarioInver.fechaNacimiento);
								
								habilitaFormularioInversionPersona();
								habilitaCombos();
								habilitaBoton('generarc','submit');
								habilitaBoton('generar','submit');
								habilitaBoton('modificarBen','submit');
								habilitaBoton('eliminarBen','submit');
								deshabilitaBoton('guardarBen','submit');
								
								// mensajeSis(beneficiarioInver.beneficiarioBen+ " "+beneficiarioInver.primerNombre);
								if(beneficiarioInver.beneficiarioBen == BeneficiariosCuenta){// Beneficiarios propios de la Cuenta
									mensajeSis("El Beneficiario no es Propio de la Inversión");									
									deshabilitaBoton('guardarBen','submit');
									deshabilitaBoton('modificarBen','submit');
									deshabilitaBoton('eliminarBen','submit');																	
									inicializaForma('formaGenerica2','beneInverID');
									consultaBeneficiariosGrid();
									reiniciaCombos2(); 
									$('#paisNac').val('');
									$('#nombreEstado').val('');
									$('#ocupacionC').val('');
									$('#parentesco').val('');
									$('#beneInverID').focus();
									$('#beneInverID').val('');
									
								}else{
									if(beneficiarioInver.clienteID > 0){												
										esTab = true;
										consultaClienteBeneficiario(beneficiarioInver.clienteID);
										deshabilitaFomInversion();															
									}else{
										consultaOcupacion('ocupacionID');														
										consultaPais('paisID');
										consultaEstado('estadoID');
									}
									consultaParentescos($('#parentescoID').val(),'');	
								}
							}else{// Diferente de Null							
								mensajeSis("No Existe el Beneficiario");
								$('#beneInverID').focus();								
								inicializaForma('formaGenerica2','beneInverID');
								deshabilitaBoton('guardarBen','submit');
								deshabilitaBoton('modificarBen','submit');
								deshabilitaBoton('eliminarBen','submit');
								reiniciaCombos2(); 
							}    						
					});
				}else{
					if(numBeneficiario == 0 && $('#inversionIDBen').asNumber() >0){ 
						habilitaBoton('guardarBen','submit');
						deshabilitaBoton('modificarBen','submit');
						deshabilitaBoton('eliminarBen','submit');
						inicializaForma('formaGenerica2','beneInverID');
						habilitaFormularioInversionPersona();
						$('#tipoIdentiID').val(''); 
					
					}
				}
			consultaBeneficiariosGrid();	
		
	}
	
	function formaCURP() {
	var sexo = $('#sexo').val();
	var nacionalidad = $('#paisID').val();
	
	if(sexo == "M")
	{sexo = "H";}
	else if(sexo == "F")
	{sexo = "M";}
	else{
		sexo = "H";
		mensajeSis("no se asigno sexo");
	}
	
	if(nacionalidad == "700")
		{nacionalidad = "N";}
		else if(nacionalidad != "")
		{nacionalidad = "S";}
		else{
			nacionalidad = "N";
			mensajeSis("no se asigno nacionalidad");
		}
	var CURPBean = {
		'primerNombre'	:$('#primerNombre').val(),
		'segundoNombre'	:$('#segundoNombre').val(),
		'tercerNombre'	:$('#tercerNombre').val(),
		'apellidoPaterno' : $('#apellidoPaterno').val(),
		'apellidoMaterno' : $('#apellidoMaterno').val(),
		'sexo'			:sexo,
		'fechaNacimiento' : $('#fechaNacimiento').val(),
		'nacion'		:nacionalidad,
		'estadoID':$('#estadoID').val()
		
	};
	clienteServicio.formaCURP(CURPBean, function(cliente) {
		if (cliente != null) {
			$('#curp').val(cliente.CURP);
		}
	});
}

	
	
	function formaRFC(){	
		var pn =$('#primerNombre').val();
		var sn =$('#segundoNombre').val();
	 	var tn =$('#tercerNombre').val();
		var nc =pn+' '+sn+' '+tn; 
	 	 	
	 	var rfcBean = { 
	 			'primerNombre':nc,
  				'apellidoPaterno':$('#apellidoPaterno').val(),
  				'apellidoMaterno':$('#apellidoMaterno').val(),
  				'fechaNacimiento':$('#fechaNacimiento').val()
				};
	 clienteServicio.formaRFC(rfcBean,function(cliente) {  
						if(cliente!=null){

						  $('#rfc').val(cliente.RFC); 
						}
	 });
   }
		

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();	
		var conPais=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numPais != '' && !isNaN(numPais)){
			paisesServicio.consultaPaises(conPais,numPais,function(pais) {
						if(pais!=null){
							if(idControl=='paisID'){							
								$('#paisNac').val(pais.nombre);
							}	else{
								$('#paisNac').val(pais.nombre);
							}							
						}else{
							mensajeSis("No Existe el Pais");
							$(jqPais).focus();
						}    						
			});
		}
	}
	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado)){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){							
							$('#nombreEstado').val(estado.nombre);																
						}else{
							mensajeSis("No Existe el Estado");							
							$(jqEstado).focus();
							$('#nombreEstado').val('');
						}    	 						
				});
			}
	}	

	function consultaEstadoDatosP(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) ) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if (estado != null) {
				var p = $('#paisID').val();
				if (p == 700 && estado.estadoID == 0 && esTab) {
					mensajeSis("No Existe el Estado");
					$('#estadoID').focus();
				}
				$('#nombreEstado').val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado");
				$('#nombreEstado').val('');
			}
			});
		}
	}
	
	function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;		
		setTimeout("$('#cajaLista').hide();", 200);		 
		
		if(numOcupacion != '' && !isNaN(numOcupacion) && numOcupacion >0){
			ocupacionesServicio.consultaOcupacion(tipConForanea,numOcupacion,function(ocupacion) {
				if(ocupacion!=null){							
					$('#ocupacionC').val(ocupacion.descripcion); 
				}else{
					mensajeSis("No Existe la Ocupacion");
					$('#ocupacionC').val(''); 
					$('#ocupacionID').focus();							
				}    	 						
			});
		}
	}
// consulta el tipo de identificacion
	function consultaTipoIden(){
		dwr.util.removeAllOptions('tipoIdentiID'); 
		dwr.util.addOptions('tipoIdentiID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('tipoIdentiID', {0:'OTRA'});	
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});
	}

// consulta el parentesco del beneficiario	
	function consultaParentescos(numParentesco,dato) {

		var tipConPrincipal = 1;
		if(numParentesco != 0){
		setTimeout("$('#cajaLista').hide();", 200);
		var parentescosBean = {
				'parentescoID'	:$('#parentescoID').val()				
				
			};
		if(numParentesco != '' && !isNaN(numParentesco)){
			parentescosServicio.consultaParentesco(tipConPrincipal, parentescosBean, function(parentesco) {
					if(parentesco!=null){
							$('#parentesco').val(parentesco.descripcion);
						}else{
							
							mensajeSis("No Existe el Parentesco");
							
						}
				});
			}
		}
	}
	
//  valida el tipo de identificacion y el numero maximo y minimo de caracteres	
	function consultaTipoIdent2(idControl, desFolio) {
		var tipConP = 1;	
		var jqTipoIdentificacion = eval("'#" + idControl + "'");
		var numIdentificacion = $(jqTipoIdentificacion).val();		
		setTimeout("$('#cajaLista').hide();", 200);					
		tiposIdentiServicio.consulta(tipConP,numIdentificacion,function(identificacion) {
			if(identificacion!=null){					
				longitudIdentificacion= identificacion.numeroCaracteres;														
				$("#"+desFolio).rules("add", {
					maxlength : identificacion.numeroCaracteres,
					minlength : identificacion.numeroCaracteres,
				messages: {
					maxlength: "Máximo "+identificacion.numeroCaracteres+" Caracteres",
					minlength: "Mínimo "+identificacion.numeroCaracteres+" Caracteres"

					}
				
				});
				
			}    	 						
		});
	}
	
	//hablita el formulario Beneficiarios inversion
	function habilitaFormularioInversionPersona(){
		 habilitaCombos();
		$('#primerNombre').attr('readOnly',false);
		$('#segundoNombre').attr('readOnly',false);
		$('#tercerNombre').attr('readOnly',false);
		$('#apellidoPaterno').attr('readOnly',false);
		$('#apellidoMaterno').attr('readOnly',false);
		$('#fechaNacimiento').removeAttr('readOnly');
		$('#paisID').attr('readOnly',false);
		$('#estadoID').attr('readOnly',false);
		$('#curp').attr('readOnly',false);
		$('#rfc').attr('readOnly',false);
		$('#generar').removeAttr('disabled');
		$('#generarc').removeAttr('disabled');
		$('#puestoA').attr('readOnly',false);
		$('#telefonoCelular').attr('readOnly',false);
		$('#telefonoCasa').attr('readOnly',false);
		$('#correo').attr('readOnly',false);
		$('#ocupacionID').attr('readOnly',false);
		$('#numIdentific').attr('readOnly',false);
		$('#fecExIden').attr('readOnly',false);
		$('#fecVenIden').attr('readOnly',false);
		$('#domicilio').attr('readOnly',false);
		$('#clavePuestoID').attr('readOnly',false);
		
		
	}
	
	//desactiva formulario
	function deshabilitaFomInversion(){
//		campos de Datos Generales de la Persona
		$('#primerNombre').attr('readOnly',true); 	
		$('#segundoNombre').attr('readOnly',true);		
		$('#tercerNombre').attr('readOnly',true);		
		$('#apellidoPaterno').attr('readOnly',true);					
		$('#apellidoMaterno').attr('readOnly',true);
		$('#fechaNacimiento').attr('readOnly',true);
		$('#paisID').attr('readOnly',true);
		$('#estadoID').attr('readOnly',true);
		$('#curp').attr('readOnly',true);	
		$('#rfc').attr('readOnly',true);	
		$('#generar').attr('disabled',true);
		$('#generarc').attr('disabled',true);
		$('#ocupacionID').attr('readOnly',true);	
		$('#puestoA').attr('readOnly',true);
		$('#clavePuestoID').attr('readOnly',true);
//		campos de Identificacion
		$('#numIdentific').attr('readOnly',true);	
		$('#fecExIden').attr('readOnly',true);
		$('#fecVenIden').attr('readOnly',true);
		$('#telefonoCasa').attr('readOnly',true);
		$('#telefonoCelular').attr('readOnly',true);					
		$('#correo').attr('readOnly',true);						
		$('#domicilio').attr('readOnly',true);	
		deshabilitaCombos();
		deshabilitaBoton('generarc','submit');
		deshabilitaBoton('generar','submit');
	}
			
	function deshabilitaCombos(){
		$('#sexo').attr('disabled',true);
		$('#titulo').attr('disabled',true);
		$('#estadoCivil').attr('disabled',true);
		$('#tipoIdentiID').attr('disabled',true);
		
	}
	
	function habilitaCombos(){
		$('#sexo').attr('disabled',false);
		$('#titulo').attr('disabled',false);
		$('#estadoCivil').attr('disabled',false);
		$('#tipoIdentiID').attr('disabled',false);
		
	}
	
	
	function consultaIdenCliente(numCliente) {
		var identificacionCliente = {
  			'clienteID': numCliente
  		};

		setTimeout("$('#cajaLista').hide();", 200);	
		if(numCliente != '' && !isNaN(numCliente) && numCliente != 0){
			  identifiClienteServicio.consulta(3,identificacionCliente,function(identificacion){					
				if(identificacion!=null){					
					$('#tipoIdentiID').val(identificacion.tipoIdentiID).selected = true;
					$('#numIdentific').val(identificacion.numIdentific);
					$('#fecExIden').val(identificacion.fecExIden);
					$('#fecVenIden').val(identificacion.fecVenIden);
					selectTipoIdenti = identificacion.tipoIdentiID;
					if(selectTipoIdenti == null){
						selectTipoIdenti = '';
					}
					if(identificacion.fecExIden=='1900-01-01' || identificacion.fecExIden=='0000-00-00'){
						$('#fecExIden').val('');	
					} 
					if(identificacion.fecVenIden == '1900-01-01' || identificacion.fecVenIden == '0000-00-00'){
						$('#fecVenIden').val('');	
					} 
								
				}else{
					selectTipoIdenti = '';
					mensajeSis("El "+$('#socioCliente').val()+" no tiene una Identificación Oficial Capturada.");
					$('#numeroCte').focus();
					$('#numeroCte').select();
			
				}
			});
		}
	}
	
	function consultaDireccion(idControl) {
		
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				 direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficialDirec,direccionCliente,function(direccion) {	
						if(direccion!=null){	
							$('#domicilio').val(direccion.direccionCompleta);
						}
				});
			}
	}
	
	// consulta la direccion de un beneficiario cuando es cliente
	function consultaDireccionCliente(numCli) {
		var numCliente = numCli;
		var direccionCliente = {
	  			'clienteID':numCliente
			};
			setTimeout("$('#cajaLista').hide();", 200);	
			if(numCliente != '' && !isNaN(numCliente)){
				 direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficialDirec,direccionCliente,function(direccion) {	
						if(direccion!=null){	
							$('#domicilio').val(direccion.direccionCompleta);
						}
				});
			}
	}
	
	function calculaEdad(fecha){
	
		if(fecha == null){
			fecha = fecha_vacia;
		}
		if(fecha < parametroBean.fechaAplicacion){
		var fechaNac=(fecha).split('-');
		var fechaActual=(parametroBean.fechaAplicacion).split('-');
		var anioNac = fechaNac[0];
		var anioAct = fechaActual[0];
		var mesNac = fechaNac[1];
		var mesAct = fechaActual[1];
		var diaNac = fechaNac[2];
		var diaAct = fechaActual[2];
		var anios = anioAct - anioNac;
		
		if(mesAct < mesNac){
			anios=anios-1;
		}
		if(mesAct = mesNac)	{
			if(diaAct < diaNac ){
				anios = anios - 1;
			}
		}
		        
		}else{			
			$('#fechaNacimiento').focus();			
			mensajeSis("La Fecha de Nacimiento es Mayor a la del Sistema.");
			$('#fechaNacimiento').val('');
		}
		
		if(anios < 18){
			esMenorEdad = 'S';			
			$('#tipoIdentiID').val(''); 
		}else{
			esMenorEdad = 'N';
		}
	}
	
});	

	function exitoBen(){
		deshabilitaBoton('agregarBen', 'submit');
		deshabilitaBoton('modificarBen', 'submit');
		deshabilitaBoton('eliminarBen','submit');
		inicializaForma('formaGenerica2','beneInverID');
		reiniciaCombos();
		consultaBeneficiariosGrid();
		
	}
	
	
	function reiniciaCombos(){
		$('#sexo').val('M');
		$('#titulo').val('SELECCIONAR');
		$('#estadoCivil').val('');
		$('#tipoIdentiID').val('');
	}
	
	function reiniciaCombos2(){
		$('#sexo').val('M').selected= true;
		$('#titulo').val('SELECCIONAR').selected =true;
		$('#estadoCivil').val('S').selected =true;
		$('#tipoIdentiID').val('').selected =true;
	}
	
	function consultaBeneficiariosGrid(){			
		var params = {};
		params['tipoLista'] = 2;	
		params['inversionID'] = $('#inversionID').val();
		$.post("gridBeneficiariosInver.htm", params, function(data){
			if(data.length >0) {			
				$('#divGridBeneficiarios').html(data);
				$('#divGridBeneficiarios').show();																
			}else{				
				$('#divGridBeneficiarios').html("");
				$('#divGridBeneficiarios').hide();			
			}
		});
	}
		
	function consultaInversion(idControl){	
		$('#beneInverID').val($('#'+idControl).val());
		$('#beneInverID').focus();
		
	}