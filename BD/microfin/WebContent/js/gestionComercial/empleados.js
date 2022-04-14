$(document).ready(function() {

	$("#empleadoID").focus();
	
			esTab = false;
			otroTab = false;
			var listado = false;

			// Definicion de Constantes y Enums
			var catTipoTransaccionEmpleados = {
				'agrega' : '1',
				'elimina' : '2',
				'modifica': '3'
			};

			var catTipoConsultaEmpleados = {
				'principal'  : 1,
				'sinEstatus' : 5

			};
			var catTipoConsultaPuestos = {
				'principal' : 1
			};

			// ------------ Metodos y Manejo de Eventos-----------------------------------------
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
			
			agregaFormatoControles('formaGenerica');

			//Validacion para mostrarar boton de calcular CURP Y RFC
			permiteCalcularCURPyRFC('generarc','generar',3);

			$(':text').focus(function() {
				esTab = false;
			});

			$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});
			
				
			$('#apellidoPat').bind('keyup',function(e){
				if(esTab="false"){
					$('#RFC').val("");
				}
		
			});
			
			$('#apellidoMat').bind('keyup',function(e){
				if(esTab="false"){
					$('#RFC').val("");
				}
		
			});
			
			 $('#empleadoID').bind('keyup',function(e){
				 if(this.value.length >= 2){ 
					var camposLista = new Array(); 
				    var parametrosLista = new Array(); 
				    	camposLista[0] = "nombreCompleto";
				    	parametrosLista[0] = $('#empleadoID').val();
				 listaAlfanumerica('empleadoID', '1', '2', camposLista, parametrosLista, 'listaEmpleados.htm'); } });


			$('#clavePuestoID').bind('keyup',function(e) {
						if (this.value.length >= 2&& isNaN($('#clavePuestoID').val())){
							var camposLista = new Array();
							var parametrosLista = new Array();
							camposLista[0] = "descripcion";
							parametrosLista[0] = $('#clavePuestoID').val();
							listaAlfanumerica('clavePuestoID', '1', '1',camposLista, parametrosLista,'listaPuestos.htm');
						}});
			
			$('#clavePuestoID').blur(function() {	
			 	if(isNaN($('#clavePuestoID').val())){
			 		consultaPuesto('clavePuestoID');
			 	 }
			});
		
			$('#sucursalID').bind('keyup',function(e) {
						lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
			});
			
		

			$('#sucursalID').blur(function() {
				esTab=true;
				consultaSucursal(this.id);
			});

			$.validator.setDefaults({submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','empleadoID','exitoTransEmpleado','falloTransEmpleado');
					$('#atiende').attr('checked', false);
					$('#atiende2').attr('checked', false);

							
						}
					});

			$('#agrega').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionEmpleados.agrega);
			});

			$('#elimina').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionEmpleados.elimina);
			});
			
			$('#modifica').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionEmpleados.modifica);
			});

			$('#empleadoID').blur(function() {
				if (esTab){
					validaEmpleado(this.id);
				}
			
			});
			$('#nacion').change(function() {
				validaNacionalidadCte();
			});
			
			$('#lugarNacimiento').bind('keyup',function(e) { 
				lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
			});

			$('#lugarNacimiento').blur(function() {
				if(esTab){
					consultaPaisNac(this.id);
				}
			});

			$('#estadoID').bind('keyup',function(e) {
				lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
			});

			$('#estadoID').blur(function() {
				if(esTab){
					consultaEstado(this.id);
				}
				
			});

			$('#sexo').change(function() {
				$('#CURP').val('');
			});

			$('#CURP').blur(function() {
				if($('#primerNombre').val() != '' && $('#fechaNacimiento').val() != '' && $('#nacion').val() != '' && $('#sexo').val() != '' && esTab){
				//	validaCURP('CURP');
					validaCURPv1($('#CURP').val());
				}				
			});

			$('#generar').click(function() {
				   formaRFC();
				   $('#clavePuestoID').focus(); 
				   
			   });

			$('#generarc').click(function() {
				if ($('#fechaNacimiento').val()!=''){
					formaCURP();
					$('#CURP').focus();
					$('#CURP').select();
				}else{
					mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
				}
			});

			// ------------ Validaciones de la Forma-------------------------------------

			$('#formaGenerica').validate({

				rules : {

					empleadoID : {
						required : true
					},

					primerNombre : {
						required : true
					},
					
					apellidoPat : {
						required : true
					},
					
					apellidoMat : {
						required : true
					},
					
					fechaNac : {
						 required: true,
						 date: true
					},
					
					RFC : {
						required : true
					},
					
					clavePuestoID : {
						required : true
					},
					
					sucursalID: {
						required: true, 
						
					},

				},
				messages : {

					empleadoID : {
						required : 'Especificar No.'
					},


					primerNombre : {
						required : 'Especificar Nombre del Empleado'
					},
					
					apellidoPat : {
						required : 'Especificar Apellido'
					},
					
					apellidoMat : {
						required : 'Especificar Apellido'
					},
					
					fechaNac : {
						required : 'Especificar Fecha',
						date: 'Fecha Incorrecta'
					},
					
					RFC : {
						required : 'Especificar RFC'
					},
					
					clavePuestoID : {
						required : 'Especificar Clave'
					},
					
					sucursalID: {
						required: 'Especifica Sucursal'
					},

				}
			});

			// ------------ Validaciones de Controles-------------------------------------

			// ////////////////funcion consultar puesto//////////////////
			function consultaPuesto(idControl) {
				var jqPuesto = eval("'#" + idControl + "'");
				var numPuesto = $(jqPuesto).val();
				setTimeout("$('#cajaLista').hide();", 200);
				var PuestoBeanCon = {
					'clavePuestoID' : numPuesto
				};

				if (numPuesto != '' && esTab) {
					puestosServicio.consulta(catTipoConsultaPuestos.principal,PuestoBeanCon, function(puestos) {
						if (puestos != null) {
							$('#puesto').val(puestos.descripcion);
							
							
							esTab = false;							
													
								if (puestos.atiendeSuc == 'S') {
									$('#atiende').attr("checked","1");
								    $('#atiende2').attr("checked",false);	
									
								} else {
										if (puestos.atiendeSuc == 'N') {
											$('#atiende2').attr("checked", "1");
											$('#atiende').attr("checked", false);											
										}
									}
						} else {
								mensajeSis("No Existe el Puesto");
								$('#puesto').val('');
								$('#clavePuestoID').focus();
								$('#ClavePuestoID').val("");
						}
				});
			}
		}

			// ////////////////funcion consultar sucursal////////////////
			function consultaSucursal(idControl) { 

				var jqSucursal = eval("'#" + idControl + "'");
				var numSucursal = $(jqSucursal).val(); 
				var conSucursal = 2;

					setTimeout("$('#cajaLista').hide();", 200);
						if (numSucursal != '' && !isNaN(numSucursal)) {
							sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
								if (sucursal != null) { 
									$('#sucursal').val(sucursal.nombreSucurs);
								} 
								else {
								mensajeSis("No Existe la sucursal");
								$('#sucursal').val('');
								$('#sucursalID').focus();
								$('#sucursalID').val("");
							}
							});
						}
			}
			
			
			
			/////////////////////funcion formar RFC//////////////////////////////
			
			function formaRFC(){	
				var pn =$('#primerNombre').val();
				var sn =$('#segundoNombre').val();
				var nc =pn+' '+sn; 
			 	 	
			 	var rfcBean = { 
			 			'primerNombre':nc,
		  				'apellidoPaterno':$('#apellidoPat').val(),
		  				'apellidoMaterno':$('#apellidoMat').val(),
		  				'fechaNacimiento':$('#fechaNac').val()
						};
			 clienteServicio.formaRFC(rfcBean,function(cliente) {  
								if(cliente!=null){

								  $('#RFC').val(cliente.RFC); 
								}
			 });
		   }
				
			
			///////////////funcion validar RFC///////////////////////////
			
			function validaRFC(idControl) {
				var jqRFC = eval("'#" + idControl + "'");
				var numRFC = $(jqRFC).val();		
				var tipCon = 3;
				setTimeout("$('#cajaLista').hide();", 200);		
				var empleadosBeanCon = {
						'RFC' : numRFC
					};
				if(numRFC != '' && esTab){
					empleadosServicio.consultaRFC(tipCon,empleadosBeanCon,function(rfc) {
								if(rfc!=null){	
		                 		deshabilitaBoton('agrega', 'submit');	
		                 		mensajeSis("existe");
											 									
								} 						
					});
				}
			}

			
			// ////////////////funcion valida Empleado//////////////////
			function validaEmpleado(control) {
				var numEmpleado = $('#empleadoID').val();
					setTimeout("$('#cajaLista').hide();", 200);
						if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {

							if (numEmpleado == '0') {
								habilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								deshabilitaBoton('elimina', 'submit');
								inicializaForma('formaGenerica', 'empleadoID');
								$('#atiende').attr('checked', false);
								$('#atiende2').attr('checked', false);
								$('#estatus').val("ACTIVO");
							} else {
								var empleadoBeanCon = {
										'empleadoID' : $('#empleadoID').val()

								};

						empleadosServicio.consulta(catTipoConsultaEmpleados.sinEstatus,empleadoBeanCon, { async: false, callback:function(empleados) {
							if (empleados != null) {
								if(empleados.estatus=='I'){

									$('#primerNombre').val(empleados.primerNombre);
									$('#segundoNombre').val(empleados.segundoNombre);
									$('#apellidoPat').val(empleados.apellidoPat);
									$('#apellidoMat').val(empleados.apellidoMat);
									$('#fechaNac').val(empleados.fechaNac);
									
									$('#nacion').val(empleados.nacion);
									$('#lugarNacimiento').val(empleados.lugarNacimiento);
									$('#estadoID').val(empleados.estadoID);
									$('#sexo').val(empleados.sexo);
									$('#CURP').val(empleados.CURP);
									$('#RFC').val(empleados.RFC);
									$('#clavePuestoID').val(empleados.clavePuestoID);
									$('#sucursalID').val(empleados.sucursalID);

									consultaPaisNac('lugarNacimiento');
									consultaEstado('estadoID');
									deshabilitaBoton('agrega', 'submit');
									deshabilitaBoton('modifica', 'submit');
									deshabilitaBoton('elimina', 'submit');
									consultaPuesto('clavePuestoID');
									consultaSucursal('sucursalID');
									$('#estatus').val("INACTIVO");
								}else{
									
									
									$('#primerNombre').val(empleados.primerNombre);
									$('#segundoNombre').val(empleados.segundoNombre);
									$('#apellidoPat').val(empleados.apellidoPat);
									$('#apellidoMat').val(empleados.apellidoMat);
									$('#fechaNac').val(empleados.fechaNac);
									
									$('#nacion').val(empleados.nacion);
									$('#lugarNacimiento').val(empleados.lugarNacimiento);
									$('#estadoID').val(empleados.estadoID);
									$('#sexo').val(empleados.sexo);
									$('#CURP').val(empleados.CURP);
									$('#RFC').val(empleados.RFC);
									$('#clavePuestoID').val(empleados.clavePuestoID);
									$('#sucursalID').val(empleados.sucursalID);
									consultaPaisNac('lugarNacimiento');
									consultaEstado('estadoID');
									
									deshabilitaBoton('agrega', 'submit');
									habilitaBoton('modifica', 'submit');
									habilitaBoton('elimina', 'submit');
									consultaPuesto('clavePuestoID');
									consultaSucursal('sucursalID');
									
									$('#estatus').val("ACTIVO");
								}	
							}else{
								if(esTab = true){
									mensajeSis("No Existe el Empleado");
									deshabilitaBoton('agrega', 'submit');
									deshabilitaBoton('modifica', 'submit');
									deshabilitaBoton('elimina', 'submit');
									inicializaForma('formaGenerica','empleadoID');
									$('#atiende').attr('checked', false);
									$('#atiende2').attr('checked', false);
									$('#empleadoID').focus();
									$('#empleadoID').select();
								}
							}
						}});

					}

				}
			}

			function validaNacionalidadCte(){
	
				var nacionalidad = $('#nacion').val();
				var pais= $('#lugarNacimiento').val();
		
				var mexico='700';
				var nacdadMex='N';
				var nacdadExtr='E';
			
				if(nacionalidad==nacdadMex){
					if(pais!=mexico && pais!=''){
						mensajeSis("Por la Nacionalidad de la Persona el País debe ser México.");
				
						$('#lugarNacimiento').focus();
						$('#lugarNacimiento').val('');
						$('#paisNac').val('');
				
				}
				}
				if(nacionalidad==nacdadExtr){
					if(pais==mexico){
						mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México.");
			
						$('#lugarNacimiento').val('');
						$('#lugarNacimiento').focus();
						$('#paisNac').val('');
					
						

					}
				}
			}


			function consultaPaisNac(idControl) {
			var jqPais = eval("'#" + idControl + "'");
			var numPais = $(jqPais).val();
			var conPais = 2;

			setTimeout("$('#cajaLista').hide();", 200);
			if (numPais != '' && !isNaN(numPais) && esTab) {
				paisesServicio.consultaPaises(conPais, numPais,	{ async: false, callback:function(pais) {
							if (pais != null) {
							
								$('#estadoID').attr('readonly',false);
								$('#paisNac').val(pais.nombre);
								if (pais.paisID != 700) {
									$('#estadoID').val(0);
									$('#estadoID').attr('readonly',true);
									consultaEstado('estadoID');
								}
							
								validaNacionalidadCte();
							} else {
								mensajeSis("No Existe el País.");
								$(jqPais).focus();
								$(jqPais).val("");
								$('#paisNac').val("");
								
							}
						}});
			}
		}


		function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
			estadosServicio
					.consulta(
							tipConForanea,
							numEstado,{ async: false, callback:
							function(estado) {
								if (estado != null) {
									var p = $('#lugarNacimiento').val();
									if (p == 700 && estado.estadoID == 0 && esTab) {
										mensajeSis("No Existe el Estado");
										$('#estadoID').focus();
									}
									$('#nombreEstado').val(estado.nombre);
								} else {
									mensajeSis("No Existe el Estado");
									$(jqEstado).val('');
									$(jqEstado).focus();
								}
							}});
		}else{
			if(esTab){
				mensajeSis("No Existe el Estado");
				$(jqEstado).val('');
				$(jqEstado).focus();
			}
		}
	}
				

	function validaCURP(idControl) {
		var jqCURP = eval("'#" + idControl + "'");
		var numCURP = $(jqCURP).val();
		var tipoPer;
		var persona;
		var tipCon = 11;
		setTimeout("$('#cajaLista').hide();", 200);
		
			persona = 'F';
		
		
		
		if (numCURP != '' && esTab ) {
			clienteServicio.consultaCURP(tipCon, numCURP,function(curp) {
				if (curp != null) {
						 numCliente = curp.numero;
						 tipoPer = curp.tipoPersona;
							clienteServicio.consulta(17, numCliente, function(cliente) {
								
								if (cliente != null) {
									var numClienteID = parseInt(cliente.numero);
										if($('#numero').val() != numClienteID){
											if(persona == 'F' || persona == 'A'){
												if(cliente.descripcionCURP!=''){
													mensajeSis(cliente.descripcionCURP +cliente.numero);
													$(jqCURP).select();	
													$(jqCURP).focus();	
												}
									}
								}
								}
							});
						 
					}
			});
		}
	}

	function validaCURPv1(curp){
	var fecha=$('#fechaNac').val();
	var regexp = /^([A-Z][A,E,I,O,U,X][A-Z]{2})(\d{2})((01|03|05|07|08|10|12)(0[1-9]|[12]\d|3[01])|02(0[1-9]|[12]\d)|(04|06|09|11)(0[1-9]|[12]\d|30))([M,H])(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)([B,C,D,F,G,H,J,K,L,M,N,Ñ,P,Q,R,S,T,V,W,X,Y,Z]{3})([0-9,A-Z][0-9])$/;
    if(regexp.test(curp) == false){
		mensajeSis('La CURP es incorrecta');
		$('#generarc').focus();
	}else{
		if(obtenFechaCurp(curp,fecha)!=true){
			 mensajeSis('La CURP no concuerda con la Fecha de Nacimiento');
		     $('#generarc').focus();
		}
	}

}

	/***********************************/
	//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
	//PRIMER PARAMETRO ID BOTON CURP
	//SEGUNDO PARAMETRO ID BOTON RFC
	//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
	function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
		var jqBotonCURP = eval("'#" + idBotonCURP + "'");
		var jqBotonRFC = eval("'#" + idBotonRFC + "'");
		var numEmpresaID = 1;
		var tipoCon = 17;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				//Validacion para mostrarar boton de calcular CURP Y RFC
				if(parametrosSisBean.calculaCURPyRFC == 'S'){
					if(tipo == 3){
						$(jqBotonCURP).show();
						$(jqBotonRFC).show();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).show();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).show();						
							}
						}
					}
				}else{
					if(tipo == 3){
						$(jqBotonCURP).hide();
						$(jqBotonRFC).hide();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).hide();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).hide();						
							}
						}
					}
				}
			}
		});
	}	




	function formaCURP() {
		var sexo = $('#sexo').val();
		var nacionalidad = $('#nacion').val();
		if(sexo == "M")
		{sexo = "H";}
		else if(sexo == "F")
		{sexo = "M";}
		else{
			sexo = "H";
			mensajeSis("Especifique Género");
		}
		
		if(nacionalidad == "N")
		{nacionalidad = "N";}
		else if(nacionalidad == "E")
		{nacionalidad = "S";}
		else{
			nacionalidad = "N";
			mensajeSis("No se Asignó Nacionalidad");
		}
		var CURPBean = {
			'primerNombre'	:$('#primerNombre').val(),
			'segundoNombre'	:$('#segundoNombre').val(),
			'tercerNombre'	: "",
			'apellidoPaterno' : $('#apellidoPat').val(),
			'apellidoMaterno' : $('#apellidoMat').val(),
			'sexo'			:sexo,
			'fechaNacimiento' : $('#fechaNac').val(),
			'nacion'		:nacionalidad,
			'estadoID':$('#estadoID').val()
			
		};
		clienteServicio.formaCURP(CURPBean, function(cliente) {
			if (cliente != null) {
				$('#CURP').val(cliente.CURP);
			}
		});
	}
	

	function obtenFechaCurp(curp,fechaNaci){
		   var esValido=true;
		   var inicioCurp=4;
		   var finCurp=10;
		   var inicio = 2;
           var fin    = 9;  
		   var exp=/([-])/;
		  
           var fechaCurp=curp.substring(inicioCurp, finCurp);
           var fechaNac=fechaNaci.replace(exp,'');
           var fechaNacimiento=fechaNac.replace(exp,'');
           if(fechaCurp==fechaNacimiento.substring(inicio,fin)){
           	 esValido=true;
           }else{
           	esValido=false;
           }

           return esValido;
	}





	

		});



	function exitoTransEmpleado(){
		$('#nacion').val('');
		$('#sexo').val('');

		limpiaFormaCompleta('formaGenerica', true, ['empleadoID']);
	}

	function falloTransEmpleado(){

	}