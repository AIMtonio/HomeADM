var Var_CasadoBienesSerpardos = 'CS';
var Var_CasadBienesMan			='CM';
var Var_CasadBienesManCipit		= 'CC';
var Var_Separado				='SE';
var Var_NombreCompletoConyuge	='';
var Var_TimpServicioCliente		='C';
var Var_TipoServicioFamiliar	='F';
var Var_TipoDocumento			= 54; // Corresponde con TIPOSDOCUMENTOS
var Var_EstatusCapturado		='C';
var Var_EstatusAutorizado		='A';
var Var_EstatusRechazado		='R';
var Var_DeshabilitaBotonesGrid	='N';
var Var_PerfilAutoriSRVFUN		=0;

//Definicion de Constantes y Enums  
var catTipoTranServFun = {
		'alta'				:	1,
		'modifica'			:	2,
		'autorizaRechaza'	:	3,
};	

$(document).ready(function() {
	esTab = false;
	//Definicion de Constantes y Enums  
	catTipoTranServFun = {
			'alta'				:	1,
			'modifica'			:	2,
			'autorizaRechaza'	:	3,
	};	

	var parametroBean = consultaParametrosSession();	
	var perfilUsuario =parametroBean.perfilUsuario; //Perfil del USuario logueado
	var usuarioLogueado	=parametroBean.numeroUsuario;
	var fechaAplic = parametroBean.fechaAplicacion;

	var ejecutaFuncion = false; 
	consultaParametrosProteccion(); // Consultamos los parametros 
	$('#serviFunFolioID').focus();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('agrega', 'submit');
	 deshabilitaBoton('modifica', 'submit');	 
	 agregaFormatoControles('formaGenerica');
	 
	$(':text').focus(function() {	
		esTab = false;	
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  ejecutaFuncion = validaAutorizaRechazo();
	    	  if(ejecutaFuncion){
	    		  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','serviFunFolioID','ExitoServiFun','ErrorServiFun');
	    	  }	     	    
	      }
	  });


	$('#serviFunFolioID').blur(function() {		
		validaServiFun(this.id);		
	});
	
	$('#agrega').click(function(){		
		$('#tipoTransaccion').val(catTipoTranServFun.alta);	
	});
	$('#modifica').click(function(){		
		$('#tipoTransaccion').val(catTipoTranServFun.modifica);	
	});
	$('#grabar').click(function(){		
		$('#tipoTransaccion').val(catTipoTranServFun.autorizaRechaza);	
	});
	
	$('#serviFunFolioID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "serviFunFolioID";
			camposLista[1] = "tramPrimerNombre";
			
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#serviFunFolioID').val();
			lista('serviFunFolioID', '2', '1', camposLista, parametrosLista, 'serviFunFoliosLista.htm');
		}				       
	});	

	
	$('#clienteID').bind('keyup',function(e){
		if($('#tipoServicio1').is(":checked")){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCompleto";
			camposLista[1] = "areaCancela";
			parametrosLista[0] = $('#clienteID').val();
			parametrosLista[1] = 'Pro';
			lista('clienteID', '2', '4', camposLista, parametrosLista, 'listaClientesCancela.htm');
		}
		if($('#tipoServicio2').is(":checked")){
			
			lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
		
	
	});
	
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '25', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#tramClienteID').bind('keyup',function(e){
		lista('tramClienteID', '2', '9', 'nombreCompleto', $('#tramClienteID').val(), 'listaCliente.htm');
	});
	$('#difunClienteID').bind('keyup',function(e){
		lista('difunClienteID', '2', '9', 'nombreCompleto', $('#difunClienteID').val(), 'listaCliente.htm');
	});

	$('#difunParentesco').bind('keyup',function(e){
		lista('difunParentesco', '2', '1', 'descripcion',$('#difunParentesco').val(), 'listaParentescos.htm');
	}); 
	$('#tramParentesco').bind('keyup',function(e){
		lista('tramParentesco', '2', '1', 'descripcion',$('#tramParentesco').val(), 'listaParentescos.htm');
	}); 
	 
	$('#clienteID').blur(function() {
		if($('#tipoServicio').val()=="C"){
			consultaSolicitudCancelaCliente(this.id);
		}else{
			consultaCliente(this.id);
		}
				
	});
	
	//--- radios
	$('#tipoServicio1').click(function(){		
		$('#tramite').show();
		$('#certificado').show();
		$('#difunto').hide();
		$('#tipoServicio1').focus();
		limpiaSeccionSocio();
		limpiaSeccionFamiliarTramite();
		limpiaSeccionDifunto();
		liampiaSeccionCertificado();
		limpiaSeccionAutorizarRechazar();
		$('#difunClienteID').val('');
		$('#difunParentesco').val('');
		$('#clienteID').val('');
		$('#tramClienteID').val('');
		$('#tramParentesco').val('');
		$('#tipoServicio').val('C');
		if($('#serviFunFolioID').asNumber() == 0){
			 habilitaBoton('agrega', 'submit');
		}
		if($('#tipoServicio1').is(":checked")){
			$('#tipoServicio2').attr("checked",false);
		}
		deshabilitaControl('noCertificadoDefun');
		deshabilitaControl('fechaCertiDefun');
		$("#fechaCertiDefun").datepicker("disable");
		
	});
	$('#tipoServicio2').click(function(){		
		$('#tramite').hide();
		$('#certificado').show();
		$('#difunto').show();
		$('#tipoServicio2').focus();
		limpiaSeccionSocio();
		limpiaSeccionFamiliarTramite();
		limpiaSeccionDifunto();
		liampiaSeccionCertificado();
		limpiaSeccionAutorizarRechazar();
		$('#difunClienteID').val('');
		$('#difunParentesco').val('');
		$('#clienteID').val('');
		$('#tramClienteID').val('');
		$('#tramParentesco').val('');
		$('#tipoServicio').val('F');		

		if($('#tipoServicio2').is(":checked")){
			$('#tipoServicio1').attr("checked",false);
		}
		
		if($('#serviFunFolioID').asNumber() == 0){
			 habilitaBoton('agrega', 'submit');
		}
		habilitaControl('noCertificadoDefun');
		habilitaControl('fechaCertiDefun');
		$("#fechaCertiDefun").datepicker("enable");
	});
		
	//--- tramite
	$('#tramClienteID').blur(function(){
		validaFamiliarTramite(this.id);
	});
	$('#tramParentesco').blur(function() {
  		consultaParentesco(this.id,'descParentescoTram');
	});
		
	// difunto
	$('#difunClienteID').blur(function() {
		validaDifunto(this.id,'difunClienteID');
	});
	$('#difunParentesco').blur(function() {
  		consultaParentesco(this.id,'descParentescoDif');
	});
	
	$('#adjuntar').click(function() {		
		if($('#clienteID').val() == null || $.trim($('#clienteID').val()) == ''){
			mensajeSis("Especifique un Cliente  ");
			$('#clienteID').focus();
		}else{			
				subirArchivos();			
		}
	});
	
	$('#autorizar').click(function(){				
		$('#usuarioAutoriza').val(usuarioLogueado);
		$('#usuarioRechaza').val('0');
		$('#motivoRechazo').val('');
		$('#lblMotivoRechazo').hide();
		$('#motivoRechazo').hide();
	});
	$('#rechazar').click(function(){				
		$('#usuarioAutoriza').val('0');
		$('#usuarioRechaza').val(usuarioLogueado);
		$('#lblMotivoRechazo').show();
		$('#motivoRechazo').show();
	});
	
	$('#tramFechaNacim').change(function() { 
		if(!esTab){			
			$('#tramFechaNacim').focus();
		}
		if($('#tramFechaNacim').val().trim()!=""){
			if(esFechaValida($('#tramFechaNacim').val())){
				if(mayor($('#tramFechaNacim').val(),fechaAplic)){
					mensajeSis("La fecha capturada es mayor a la de hoy");
					$('#tramFechaNacim').val("");	
					$('#tramFechaNacim').focus();

				}else{	
						$('#tramFechaNacim').focus();
				}
			}else{
				$('#tramFechaNacim').focus();
				$('#tramFechaNacim').val("");
			}
		}
	}); 
	
	$('#fechaCertiDefun').change(function() { 
		if(!esTab){			
			$('#fechaCertiDefun').focus();
		}
		if($('#fechaCertiDefun').val().trim()!=""){
			if(esFechaValida($('#fechaCertiDefun').val())){
				if(mayor($('#fechaCertiDefun').val(),fechaAplic)){
					mensajeSis("La fecha capturada es mayor a la de hoy");
					$('#fechaCertiDefun').val("");	
					$('#fechaCertiDefun').focus();

				}else{	
					$('#fechaCertiDefun').focus();
				}
			}else{
				$('#fechaCertiDefun').focus();
				$('#fechaCertiDefun').val("");
			}
		}
	}); 
	
	$('#difunFechaNacim').change(function(){
		if(!esTab){			
			$('#difunFechaNacim').focus();
		}
		if($('#difunFechaNacim').val().trim()!=""){
			if(esFechaValida($('#difunFechaNacim').val())){
				if(mayor($('#difunFechaNacim').val(),fechaAplic)){
					mensajeSis("La fecha capturada es mayor a la de hoy");
					$('#difunFechaNacim').val("");	
					$('#difunFechaNacim').focus();

				}else{	
					$('#difunFechaNacim').focus();
				}
				
			}else{
				$('#difunFechaNacim').focus();
				$('#difunFechaNacim').val("");
			}
		}
	
	});

	//-----------validacion de la Forma--------
	$('#formaGenerica').validate({
		rules:{
			clienteID:{
				required:true
			},			
			noCertificadoDefun:{
				required:true
			},
			fechaCertiDefun:{
				required:true,
				date: true
			},
			tramFechaNacim:{
				required: function() {
					return $('#tipoServicio1').attr('checked') == true;
					date: true;}
				
			},
			difunFechaNacim:{				
				date: true
			},
			tipoServicio:{				
				required:true
			},
			motivoRechazo:{				
				required: function() {
					return $('#rechazar').attr('checked') == true;
				}
			}			
		},
		messages:{
			clienteID:{
				required:'Ingrese un número de Cliente'
			},
			noCertificadoDefun:{
				required:'Ingrese el Número del Certificado de Defunción'
			},
			fechaCertiDefun:{
				required:'Ingrese la Fecha del Certificado de Defunción',
				date: 'Fecha Inválida'
			},
			tramFechaNacim:{				
				date: 'Fecha Inválida'
			},
			difunFechaNacim:{				
				date: 'Fecha Inválida'
			},
			tipoServicio1:{				
				required:'Seleccione un Tipo de Servicio'
			},
			motivoRechazo:{				
				required:'Especifique el Motivo del Rechazo'
			}
			
		}
	});
	
	
	//------------ Validaciones de Controles -------------------------------------	
	function  validaServiFun(idControl) { 
		var jqFolio = eval("'#" + idControl + "'");
		var numFolio = $(jqFolio).val();
		var tipConPrincipal = 1;	
		inicializaFormaServifunFolios();			
		
		setTimeout("$('#cajaLista').hide();", 200);			
		var proteccionBeanP = {
				'serviFunFolioID': numFolio								
			};

		if(numFolio != '' && !isNaN(numFolio)){
			if(numFolio > 0){
				serviFunFoliosServicio.consulta(tipConPrincipal,proteccionBeanP,function(proteccion) {
					if(proteccion!=null){		
						dwr.util.setValues(proteccion);
						$('#tipoServicio').val(proteccion.tipoServicio);
						if(proteccion.tipoServicio == Var_TimpServicioCliente){
							$('#tramite').show();
							$('#certificado').show();
							$('#difunto').hide();	
							consultaParentesco('tramParentesco','descParentescoTram');
							$('#tipoServicio1').attr("checked",true);
							$('#tipoServicio2').attr("checked",false);
							deshabilitaControl('noCertificadoDefun');
							deshabilitaControl('fechaCertiDefun');
							$("#fechaCertiDefun").datepicker("disable");
						}else if(proteccion.tipoServicio == Var_TipoServicioFamiliar){
							$('#tramite').hide();
							$('#certificado').show();
							$('#difunto').show();
							consultaParentesco('difunParentesco','descParentescoDif');
							$('#tipoServicio2').attr("checked",true);
							$('#tipoServicio1').attr("checked",false);
							habilitaControl('noCertificadoDefun');
							habilitaControl('fechaCertiDefun');
							$("#fechaCertiDefun").datepicker("enable");
						}
						if(perfilUsuario == Var_PerfilAutoriSRVFUN ){								
							$('#autorizarDiv').show();						
							$('#estatus').val(proteccion.estatus).selected = true;
							if(proteccion.estatus == Var_EstatusAutorizado){
								$('#autorizar').attr('checked',true);
								$('#rechazar').attr('checked',false);
								$('#lblMotivoRechazo').hide();
								$('#motivoRechazo').hide();
								mensajeSis("El Folio se encuentra Autorizado");
							}else if(proteccion.estatus == Var_EstatusRechazado){
								$('#autorizar').attr('checked',false);
								$('#rechazar').attr('checked',true);
								$('#lblMotivoRechazo').show();
								$('#motivoRechazo').show();
								mensajeSis("El Folio se encuentra Rechazado");
							}else{
								$('#autorizar').attr('checked',true);
								$('#rechazar').attr('checked',false);
								
								$('#usuarioAutoriza').val(usuarioLogueado);
								$('#usuarioRechaza').val('0');
								$('#motivoRechazo').val('');
								$('#lblMotivoRechazo').hide();
								$('#motivoRechazo').hide();
							}
						}else{
							$('#autorizarDiv').hide();
						}	
						if(proteccion.estatus == Var_EstatusCapturado){
							habilitaBoton('modifica', 'submit');								
							Var_DeshabilitaBotonesGrid ='N';
							habilitaBoton('grabar', 'submit'); 
							habilitaControles();						
						}else{
							deshabilitaBoton('modifica', 'submit');	
							Var_DeshabilitaBotonesGrid ='S';
							deshabilitaControles();
						}
						if(proteccion.difunClienteID == 0){
							$('#difunClienteID').val('');
							$("#difunFechaNacim").datepicker("enable");
						}else{
							$("#difunFechaNacim").datepicker("disable"); 
						}
						if(proteccion.difunParentesco == 0){
							$('#difunParentesco').val('');
						}
						if(proteccion.tramClienteID == 0){
							$('#tramClienteID').val('');
							$("#tramFechaNacim").datepicker("enable");;
						}else{
							$("#tramFechaNacim").datepicker("disable");  
						}
						if(proteccion.tramParentesco == 0){
							$('#tramParentesco').val('');
						}
						consultaArchivosCliente();
						consultaCliente('clienteID');
						deshabilitaBoton('agrega', 'submit');
														
					}else{
						mensajeSis("No existe el Folio.");
						inicializaFormaServifunFolios();
						$(jqFolio).focus();
						$(jqFolio).val("");
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				});	
			}else{
				if(numFolio == 0){
					if($('#tipoServicio1').attr('checked')== true || $('#tipoServicio2').attr('checked') ==true){
						 habilitaBoton('agrega', 'submit');
					}					
					deshabilitaBoton('modifica', 'submit');	
					inicializaFormaServifunFolios();
					deshabilitaBoton('adjuntar', 'submit');
					$('#adjuntar').hide();
					habilitaControles();
				}
			}
					
		}
	}
	
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		limpiaSeccionSocio();
		setTimeout("$('#cajaLista').hide();", 200);			
		
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			
			clienteServicio.consulta(tipConPrincipal,numCliente, function(cliente) {
				if (cliente != null) {
					$('#nombreCte').val(cliente.nombreCompleto);					
					$('#fechaNacimiento').val(cliente.fechaNacimiento);
					$('#rfc').val(cliente.RFC);					
					$('#curp').val(cliente.CURP);
					$('#fechaIngreso').val(cliente.fechaAlta);
					$('#edadIngreso').val(Math.abs(calcular_edad(cliente.fechaNacimiento,cliente.fechaAlta)));
					if(cliente.estadoCivil == Var_CasadoBienesSerpardos || 
							cliente.estadoCivil == Var_CasadBienesMan || 
							cliente.estadoCivil == Var_CasadBienesManCipit || 
							cliente.estadoCivil == Var_Separado ){
						$('#conyuge').show();
						consultaDatosConyugue();
					}else{
						$('#conyuge').hide();
					}
				
					if(cliente.tipoPersona == 'F'){
						$('#tipoPersona').val('FÍSICA');
					}else{
						if(cliente.tipoPersona == 'A'){
							$('#tipoPersona').val('FÍSICA ACT. EMP.');
						}else{
							$('#tipoPersona').val('MORAL');
						}
					}	
					
					if($('#tipoServicio').val() == "C" && $('#serviFunFolioID').asNumber()=="0"){
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit'); 
					}
					
					if($('#tipoServicio2').is(":checked") && cliente.estatus=="I" ){						
						mensajeSis("El "+$('#alertSocio').val()+" se encuentra Inactivo");
						$('#conyuge').hide();
						$('#clienteID').focus();
						$('#clienteID').val('');	
						limpiaSeccionSocio();
						
					}

					
				}else{
					mensajeSis("No Existe el "+$('#alertSocio').val());				
					$('#clienteID').focus();
					$('#clienteID').select();	
					limpiaSeccionSocio();
				}
				
			
			});
		}
	}
	
	
	
	function calcular_edad(fechaNacimiento, fechaIngresoCli) {
		var edad  = 0; 
		if(fechaNacimiento == "" || fechaNacimiento == null ){
			mensajeSis("Se requiere Fecha de Nacimiento para Calcular la Edad.");
			edad = 0;
		}else{
			if(fechaIngresoCli == "" || fechaIngresoCli == null){
				mensajeSis("Se requiere Fecha de Ingreso para Calcular la Edad.");
				edad = 0;
			}else{
				FechaNac = fechaNacimiento.split("-");
				FechaIngreso = fechaIngresoCli.split("-");
				var diaCumple = FechaNac[2];
				var mesCumple = FechaNac[1];
				var yyyyCumple = FechaNac[0];
				
				var diaIngreso =FechaIngreso[2];
				var mesIngreso =FechaIngreso[1];
				var anioIngreso =FechaIngreso[0];
				//retiramos el primer cero de la izquierda
				if (mesCumple.substr(0,1) == 0) {
					mesCumple= mesCumple.substring(1, 2);
				}
				//retiramos el primer cero de la izquierda
				if (diaCumple.substr(0, 1) == 0) {
					diaCumple = diaCumple.substring(1, 2);
				}
				edad = anioIngreso - yyyyCumple;

				/*validamos si el mes de cumpleaños es menor al actual
				o si el mes de cumpleaños es igual al actual
				y el dia actual es menor al del nacimiento
				De ser asi, se resta un año*/
				if ((mesIngreso < mesCumple) || (mesIngreso == mesCumple && diaIngreso < diaCumple)) {
					edad--;
				}
			}
		}
		return edad;
	};
	
	function consultaDatosConyugue(){
		Var_NombreCompletoConyuge = '';
		var tipolistaPrincipal= {
			'principal': 1			
		};
		var clienteID = $('#clienteID').val();		
		var datSocConyugueBean = {
			'prospectoID': 0,
			'clienteID':  clienteID
		};
		socDemoConyugServicio.consulta(tipolistaPrincipal.principal,datSocConyugueBean ,function(conyugue){ 
			if(conyugue!=null){				
				if(conyugue.primerNombre != ''){
					Var_NombreCompletoConyuge =Var_NombreCompletoConyuge+' '+conyugue.primerNombre;
				}
				if(conyugue.segundoNombre != ''){
					Var_NombreCompletoConyuge =Var_NombreCompletoConyuge+' '+conyugue.segundoNombre;
				}
				if(conyugue.tercerNombre != ''){
					Var_NombreCompletoConyuge =Var_NombreCompletoConyuge+' '+conyugue.tercerNombre;
				}
				if(conyugue.apellidoPaterno != ''){
					Var_NombreCompletoConyuge =Var_NombreCompletoConyuge+' '+conyugue.apellidoPaterno;
				}				
				if(conyugue.apellidoMaterno!= ''){
					Var_NombreCompletoConyuge =Var_NombreCompletoConyuge+' '+conyugue.apellidoMaterno;
				}	
					
				$('#clienteIDConyuge').val(conyugue.clienteConyID);					
				$('#nombreCteConyuge').val( Var_NombreCompletoConyuge);	
				$('#fechaNacimientoConyuge').val(conyugue.fecNacimiento);				
				$('#RFCConyuge').val(conyugue.rfcConyugue);	
			
			 }	
		});
		
  	}
	
	function validaFamiliarTramite(idControl){
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		limpiaSeccionFamiliarTramite();
		setTimeout("$('#cajaLista').hide();", 200);			
		
		if(numCliente != '' && !isNaN(numCliente) ){
			if(numCliente >0){
				clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
					if(cliente!=null){	
						desHabilitaSeccionTramiteFamiliar();
						$('#tramPrimerNombre').val(cliente.primerNombre);
						$('#tramSegundoNombre').val(cliente.segundoNombre);
						$('#tramTercerNombre').val(cliente.tercerNombre);
						$('#tramApePaterno').val(cliente.apellidoPaterno);
						$('#tramApeMaterno').val(cliente.apellidoMaterno);
						$('#tramFechaNacim').val(cliente.fechaNacimiento);	
						$('#tramParentesco').focus();

						$("#tramFechaNacim").datepicker("disable");
					}else{
						mensajeSis("No Existe el "+$('#alertSocio').val());				
						$('#clienteID').focus();
						$('#clienteID').select();
						limpiaSeccionFamiliarTramite();
					}
				});
			}else{
				//habilita controles 				
				habilitaSeccionTramiteFamiliar();
				$("#tramFechaNacim").datepicker("enable");
			}
			
		}
	}
	function habilitaSeccionTramiteFamiliar(){
		habilitaControl('tramPrimerNombre');
		habilitaControl('tramSegundoNombre');
		habilitaControl('tramTercerNombre');
		habilitaControl('tramApePaterno');
		habilitaControl('tramApeMaterno');
		habilitaControl('tramFechaNacim');
		limpiaSeccionFamiliarTramite();		
		$('#tramPrimerNombre').focus();
		
	}
	function desHabilitaSeccionTramiteFamiliar(){
		deshabilitaControl('tramPrimerNombre');
		deshabilitaControl('tramSegundoNombre');
		deshabilitaControl('tramTercerNombre');
		deshabilitaControl('tramApePaterno');
		deshabilitaControl('tramApeMaterno');
		deshabilitaControl('tramFechaNacim');
	}
	
	function validaDifunto(idControl){
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;
		limpiaSeccionDifunto();
		setTimeout("$('#cajaLista').hide();", 200);			
		
		if(numCliente != '' && !isNaN(numCliente) ){
			if(numCliente >0){
				clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
					if(cliente!=null){	
						desHabilitaSeccionDifunto();
						$('#difunPrimerNombre').val(cliente.primerNombre);
						$('#difunSegundoNombre').val(cliente.segundoNombre);
						$('#difunTercerNombre').val(cliente.tercerNombre);
						$('#difunApePaterno').val(cliente.apellidoPaterno);
						$('#difunApeMaterno').val(cliente.apellidoMaterno);
						$('#difunFechaNacim').val(cliente.fechaNacimiento);		
						$('#difunParentesco').focus();

						$("#difunFechaNacim").datepicker("disable");
						
					}else{
						mensajeSis("No Existe el "+$('#alertSocio').val());				
						$('#clienteID').focus();
						$('#clienteID').select();	
						limpiaSeccionDifunto();
					}
				});
			}else{
				//habilita botones algo asi				
				habilitaSeccionDifunto();
				limpiaSeccionDifunto();
				$("#difunFechaNacim").datepicker("enable");
				
				
			}
			
		}
	}
	
	function habilitaSeccionDifunto(){
		habilitaControl('difunPrimerNombre');
		habilitaControl('difunSegundoNombre');
		habilitaControl('difunTercerNombre');
		habilitaControl('difunApePaterno');
		habilitaControl('difunApeMaterno');
		habilitaControl('difunFechaNacim');
	}

	function desHabilitaSeccionDifunto(){
		deshabilitaControl('difunPrimerNombre');
		deshabilitaControl('difunSegundoNombre');
		deshabilitaControl('difunTercerNombre');
		deshabilitaControl('difunApePaterno');
		deshabilitaControl('difunApeMaterno');
		deshabilitaControl('difunFechaNacim');
	}

	function consultaParentesco(idControl,descCampo) {
		var jqParentesco = eval("'#" + idControl + "'");
		var numParentesco = $(jqParentesco).val();	
			
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var ParentescoBean = {
				'parentescoID' : numParentesco
		};
		if(numParentesco != '' && !isNaN(numParentesco)){
			parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
					if(parentesco!=null){
						$('#'+descCampo).val(parentesco.descripcion);
					}else{
						mensajeSis("No Existe el Parentesco");	
						$(jqParentesco).val('');
						$(jqParentesco).focus();
					}
				});
			}
	}
	
	function consultaParametrosProteccion() {			
		setTimeout("$('#cajaLista').hide();", 200);		
			var empresaBean = {
					'empresaID':1 
			};									
			parametrosCajaServicio.consulta(1,empresaBean,function(parametrosCaja) {
			if(parametrosCaja != null){						
				Var_PerfilAutoriSRVFUN = parametrosCaja.perfilAutoriSRVFUN;					
			}else{
				Var_PerfilAutoriSRVFUN = parseFloat(0);		
			}
			});
			
	}	

	
	function consultaUsuario(control,nombreUsuario) {	
		var jqUsuario = eval("'#" + control + "'");
		var jqNombreUsuario = eval("'#" + nombreUsuario + "'");
		
		var numUsuario = $(jqUsuario).val();			
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){		
			var usuarioBeanCon = {
					'usuarioID':numUsuario 
			};									
			usuarioServicio.consulta(2,usuarioBeanCon,function(usuario) {
			if(usuario!=null){											
				$(jqNombreUsuario).val(usuario.nombreCompleto);					

			}else{
				$(jqUsuario).focus();
				$(jqUsuario).val("");
				$(jqNombreUsuario).val("");
			}
			});
		}	
	}	

	// ::::::::::::::::::::::::::ARCHIVOS ::::::::::::::::
	function subirArchivos() {
		//var url ="clientesFileUploadVista.htm?Cte="+$('#clienteID').val()+"&td="+Var_TipoDocumento+"&pro="+$('#prospectoID').val();		
		var url ="clientesArchivosUploadVista.htm?Cte="+$('#clienteID').val()+"&td="+Var_TipoDocumento+"&pro="+$('#prospectoID').val()+"&instrumento="+$('#serviFunFolioID').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);	
	}


	/* funcion para validar que el cliente tenga una solicitud de cancelacion de socio por 
	 * protecciones,*/
	function consultaSolicitudCancelaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var varClienteID = $(jqCliente).val();	
		var tipConCliente = 3;
		setTimeout("$('#cajaLista').hide();", 200);		
		if (varClienteID != '' && !isNaN(varClienteID)) { // si es numero y no esta vacio el campo
			var clienteCancelaBean = {
				'clienteID'	:varClienteID.trim()
			};
			if($('#serviFunFolioID').asNumber() == 0){ /* si se trata del alta de una nueva solicitud de cancelacion*/			
				clientesCancelaServicio.consulta(tipConCliente,clienteCancelaBean,function(cliente) {					
					if(cliente!=null){					
						$('#noCertificadoDefun').val(cliente.actaDefuncion);
						$('#fechaCertiDefun').val(cliente.fechaDefuncion);
						esTab=true;
						consultaCliente(idControl);
					}else{
						mensajeSis("El "+$('#alertSocio').val()+" No Tiene una Solicitud de Cancelación.");
						inicializaFormaServifunFoliosSinCancel();
						$(jqCliente).focus();
						$(jqCliente).val("");
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
					}
				});
			}else{
				consultaCliente(idControl);
			}
			
		}	
	}


	
	
});
//---FIN

function ExitoServiFun(){
	inicializaFormaServifunFolios();
}
function ErrorServiFun(){
	
}

function inicializaFormaServifunFolios(){		
	$('#conyuge').hide();
	$('#tramite').hide();
	$('#difunto').hide();
	$('#certificado').hide();
	$('#autorizarDiv').hide();
	$('#fielSetArchivosCliente').hide();
	$('#gridArchivos').hide();
	$('#gridArchivos').html('');
	$('#clienteID').val('');	
	$('#tramClienteID').val('');	
	$('#difunClienteID').val('');	
	$('#tipoServicio1').attr('checked',false);
	$('#tipoServicio2').attr('checked',false);
	 deshabilitaBoton('agrega', 'submit');
	 deshabilitaBoton('modifica', 'submit');
	$('#estatus').val("C").selected = true;
	 
	limpiaSeccionSocio();
	limpiaSeccionFamiliarTramite();
	limpiaSeccionDifunto();
	liampiaSeccionCertificado();
	limpiaSeccionAutorizarRechazar();
}

function inicializaFormaServifunFoliosSinCancel(){		
	$('#conyuge').hide();
	$('#tramite').hide();
	$('#difunto').hide();
	$('#certificado').hide();
	$('#autorizarDiv').hide();
	$('#fielSetArchivosCliente').hide();
	$('#gridArchivos').hide();
	$('#gridArchivos').html('');
	$('#clienteID').val('');	
	$('#tramClienteID').val('');	
	$('#difunClienteID').val('');	
	$('#estatus').val("C").selected = true;
	 
	limpiaSeccionSocio();
	limpiaSeccionFamiliarTramite();
	limpiaSeccionDifunto();
	liampiaSeccionCertificado();
	limpiaSeccionAutorizarRechazar();
}

function limpiaSeccionSocio(){
	//$('#clienteID').val('');
	$('#nombreCte').val('');
	$('#fechaNacimiento').val('');
	$('#rfc').val('');
	$('#tipoPersona').val('');
	$('#curp').val('');
	$('#estadoCivil').val('').selected;
	$('#fechaIngreso').val('');
	$('#edadIngreso').val('');
	$('#clienteIDConyuge').val('');
	$('#nombreCteConyuge').val('');
	$('#fechaNacimientoConyuge').val('');
	$('#RFCConyuge').val('');
}
function limpiaSeccionFamiliarTramite(){
	//$('#tramClienteID').val('');
	$('#tramPrimerNombre').val('');
	$('#tramSegundoNombre').val('');
	$('#tramTercerNombre').val('');
	$('#tramApePaterno').val('');
	$('#tramApeMaterno').val('');
	$('#tramFechaNacim').val('');
	$('#descParentescoTram').val('');	
	$('#tramParentesco').val('');	
}
function limpiaSeccionDifunto(){
	//$('#difunClienteID').val('');
	$('#difunPrimerNombre').val('');
	$('#difunSegundoNombre').val('');
	$('#difunTercerNombre').val('');
	$('#difunApePaterno').val('');
	$('#difunApeMaterno').val('');
	$('#difunFechaNacim').val('');
	$('#difunParentesco').val('');
	$('#descParentescoDif').val('');
}
function liampiaSeccionCertificado(){
	$('#noCertificadoDefun').val('');
	$('#fechaCertiDefun').val('');
	$('#fielSetArchivosCliente').hide();
	$('#gridArchivos').hide();
	$('#gridArchivos').html('');
}
function limpiaSeccionAutorizarRechazar(){
	$('#motivoRechazo').val('');
	deshabilitaBoton('grabar', 'submit');
	$('#autorizar').attr('checked',false);
	$('#rechazar').attr('checked',false);
}

//::::::::::::::::::::  ARCHIVOS CLIENTE ::::::::::::::::::::::::::::::::::.
function consultaArchivosCliente(){		
	var params = {};
	params['tipoLista'] = 2; // por instrumento
	params['clienteID'] = $('#clienteID').val();
	params['prospectoID'] = 0;
	params['tipoDocumento'] = Var_TipoDocumento;
	params['instrumento'] = $("#serviFunFolioID").val();
	//$.post("documentosClienteGridServi.htm", params, function(data){
	$.post("documentosClienteGridGeneral.htm", params, function(data){	
			if(data.length >0) {				
				$('#fielSetArchivosCliente').show();
				$('#gridArchivos').html(data);
				$('#gridArchivos').show();
				$('#adjuntar').show();				
				if(Var_DeshabilitaBotonesGrid == 'S' ){
					deshabilitabotonesArchivosCte();
				}else{
					habilitabotonesArchivosCte();
				}
				
			}else{
				$('#fielSetArchivosCliente').hide();
				
			}
	});	
}
function verArchivosCliente(id, idTipoDoc, idarchivo,recurso) {
	var varClienteVerArchivo = $('#clienteID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varTipoConVerArchivo = 10;
	var parametros = "?clienteID="+varClienteVerArchivo+"&prospectoID="+$('#prospectoID').val()+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&recurso="+recurso;

	var pagina="clientesVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
		$('#imgCliente').attr("src",pagina); 		
		$('#imagenCte').html(); 
		  $.blockUI({message: $('#imagenCte'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 400) /2 + 'px', 
           width: '400px' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		//$('#enlaceTicket').attr('href',pagina);
		window.open(pagina,'_blank');
		$('#imagenCte').hide();

	}	
}
//funcion para eliminar el documento digitalizado
function  eliminaArchivo(folioDocumento){
	if($('#estatus').val() =='C' ){
		var bajaFolioDocumentoCliente = 1;
		var clienteArchivoBean = {
			'clienteID'	:$('#clienteID').val(),
			'clienteArchivosID'	:folioDocumento
		};
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
		$('#contenedorForma').block({
				message: $('#mensaje'),
			 	css: {border:		'none',
			 			background:	'none'}
		});
		clienteArchivosServicio.bajaArchivosCliente(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
			if(mensajeTransaccion!=null){
				mensajeSis(mensajeTransaccion.descripcion);
				$('#contenedorForma').unblock(); 
				consultaArchivosCliente();

			}else{				
				mensajeSis("Existio un Error al Borrar el Documento");			
			}
		});
	}else{
		mensajeSis("Solo se pueden eliminar archivos de una solicitud con estatus Capturado.");
	}
	
}



function deshabilitabotonesArchivosCte(){	
	/*$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina"+numero+"'");	
		deshabilitaControl(idCampo);
		
	});*/
	deshabilitaBoton('adjuntar', 'submit');
}
function habilitabotonesArchivosCte(){
	$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina" + numero+ "'");	
		habilitaControl(idCampo);
	});
	 habilitaBoton('adjuntar', 'submit');
}


//funcion para validar la fecha
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
			case 1: case 3:  case 5: case 7: case 8: case 10: case 12:	
				numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
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

function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

/* funcion para habilitar los controles cuando la solicitud 
 * puede ser modificada (que esten Estatus C) o se captura  una nueva */
function habilitaControles(){
	habilitaControl('tipoServicio1');
	habilitaControl('tipoServicio2');
	habilitaControl('autorizar');
	habilitaControl('rechazar');
	habilitaControl('motivoRechazo');	 

	$("#tramFechaNacim").datepicker("enable");
	// $("#fechaCertiDefun").datepicker("enable");
	$("#difunFechaNacim").datepicker("enable");
}

/* funcion para deshabilitar los controles cuando la solicitud 
 * no puede ser modificada , es decir, que este autorizada o rechazada  */
function deshabilitaControles(){
	soloLecturaControl('tipoServicio1');	
	soloLecturaControl('tipoServicio2');
	soloLecturaControl('autorizar');
	soloLecturaControl('rechazar');
	soloLecturaControl('motivoRechazo');
	
	deshabilitaControl('tipoServicio1');
	deshabilitaControl('tipoServicio2');
	deshabilitaControl('autorizar');
	deshabilitaControl('rechazar');
	deshabilitaControl('motivoRechazo');	
	
	$("#tramFechaNacim").datepicker("disable");
	$("#fechaCertiDefun").datepicker("disable");
	$("#difunFechaNacim").datepicker("disable");
}


/* funcion para validar los datos requeridos al autorizar o rechazar 
 * la solicitud del beneficio PROFUN*/
function validaAutorizaRechazo(){
	var procede = false;
	if( $('#tipoTransaccion').val()==catTipoTranServFun.autorizaRechaza){
		if($('#rechazar').is(":checked")){
			if($('#motivoRechazo').val().trim() == "" && $('#rechazar').is(":checked")){
				mensajeSis("Especificar Motivo de Rechazo");
				$('#motivoRechazo').focus();
				procede = false;
			}else{
				procede = true;
			}	
		}else{
			if($('#autorizar').is(":checked")){
				procede = true;
			}else{
				mensajeSis("Especificar Operacion a Realizar");
				$('#autorizaProfun').focus();
				procede = false;
			}
		}					
	}else{
		procede = true;
	}	
	return procede; 
}
// Funcion para validar si la fecha es mayor a la del sistema
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