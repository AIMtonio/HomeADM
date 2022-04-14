var esTab=false;
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	esTab = true;
	$('#clienteID').focus();
	 
	//Definicion de Constantes y Enums  
	
	// Alta de los registros encontrados como persona SEIDO
	var catTipoTransaccionReqSeido = {
			'alta' : 1
	};
	var catTipoConsultaOpeInusuales = {
			'principal'	: 1  		
	};	

	var nombreAnterior = '';

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if ($('#tipoTransaccion').asNumber() == catTipoTransaccionReqSeido.alta) {
				if ($('#clienteID').val().trim() != '' && $('#clienteID').asNumber() > 0) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'clienteID', 'funcionExito', 'funcionFallo');
				}
			}
		}
	});	
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '10', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 

	$('#clienteID').blur(function(){
		consultaCliente(this.id);
		
		if($('#clienteID').val() == '' && $('#nombreCompleto').val() == ''){
			$('#gridRelacionadosCuenta').html("");			
			$('#gridRelacionadosInversion').html("");			
			$('#gridCreAvales').html("");	
			$('#gridClientes').html("");
			deshabilitaBoton('buscarcli');
			deshabilitaBoton('imprimir');
		} else if($('#clienteID').asNumber()>0){
			habilitaBoton('buscarcli');
			deshabilitaBoton('imprimir');
		}
	});

	$('#buscarcli').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionReqSeido.alta);
		if($('#clienteID').val().trim()!='' && $('#clienteID').asNumber()>0){
			consultaListas($('#clienteID').val());
		} else {
			deshabilitaBoton('buscarcli');
			deshabilitaBoton('imprimir');
		}
	});	
	
	$('#imprimir').click(function(){
		$('#tipoTransaccion').val(0);
		if($('#clienteID').val().trim()!='' && $('#clienteID').asNumber()>0){
			var usuario 	 = parametroBean.claveUsuario;
			var nombreInstitucion = parametroBean.nombreInstitucion;
			var clienteID = $('#clienteID').asNumber();
			var nombreCompleto = $("#nombreCompleto").val();
			var liga = 'repBusqRelOpIli.htm?'+
			'tipoReporte='+1+
			'&usuario='+usuario+
			'&nombreInstitucion='+nombreInstitucion+
			'&ClavePersonaInv='+clienteID+
			'&nombreCompleto='+nombreCompleto;
			window.open(liga, '_blank');
		}
	});	
	
	
	deshabilitaBoton('buscarcli');
	deshabilitaBoton('imprimir');
	
	
	/*Se regresa la pantalla a su estado original si el número de socio es borrado*/
	$('#clienteID').bind('keydown', function(e){
			$('#nombreCompleto').val("");
			$("#bloqueada").attr("checked", false);
			$("#listaNegra").attr("checked", false);
			$('#gridRelacionadosCuenta').html("");			
			$('#gridRelacionadosInversion').html("");			
			$('#gridCreAvales').html("");	
			$('#gridClientes').html("");
			deshabilitaBoton('buscarcli');
			deshabilitaBoton('imprimir');
	});

	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		
		rules: {
			clienteID: {
				required: function() {return $('#clienteID').val()=='' && $('#nombreCompleto').val()== ''; }
			},
			nombreCompleto: {
				required: function() {return $('#clienteID').val()=='' && $('#nombreCompleto').val()== ''; },	
			},
		},		
		messages: {
			clienteID: {
				required: 'Especifique el Número de '+ $('#alertSocio').val()
			},
			nombreCompleto: {
				required: 'Especifique Nombre Completo'
			},
		}		
	});	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	// ////////////////funcion consultar cliente////////////////
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && Number(numCliente)>0){
			clienteServicio.consulta(catTipoConsultaOpeInusuales.principal,numCliente,function(cliente) {
						if(cliente != null ){	
							if(cliente.estatus=='I')	{
								mensajeSis(' El '+' '+ $('#alertSocio').val()+' '+'se encuentra inactivo');
								$('#clienteID').focus();
								$('#clienteID').val('');
								$('#nombreCompleto').val('');
								deshabilitaBoton('imprimir');
							}
							else{
								$('#nombreCompleto').val(cliente.nombreCompleto);
								habilitaBoton('buscarcli');
								deshabilitaBoton('imprimir');
								nombreAnterior = $('#nombreCompleto').val();	
								deshabilitaControl('nombreCompleto');
								$("#buscarcli").focus();
							}				
											
						}else{
							mensajeSis('No Existe el '+ $('#alertSocio').val());
							$('#clienteID').focus();
							$('#clienteID').val('');
							$('#nombreCompleto').val('');
							deshabilitaBoton('buscarcli');
							deshabilitaBoton('imprimir');
						}
				});
			}  
		}
		
	});
	//Consulta si el cliente se encuentra en una lista negra o de personas bloqueadas
	function consultaListas(idControl) {
		var numCliente = idControl;
		var tipoConNeg = 2;
		var tipoConBloq =2;
		var parametrosListaNEgra = {
				'listaNegraID'	:numCliente
		};
		var parametrosListaBloq = {
				'personaBloqID'	:numCliente,	
				'tipoPers'		: 'CTE'	
		};
		pldListaNegrasServicio.consulta(tipoConNeg,parametrosListaNEgra,{ async: false, callback:function(data){
			if(data.esListaNegra !='N' ){
				$("#listaNegra").attr("checked", true);
			} else {
				$("#listaNegra").attr("checked", false);
			}
		}});

		pldListasPersBloqServicio.consulta(tipoConBloq,parametrosListaBloq,{ async: false, callback:function(data){
			if(data.estaBloqueado !='N' )	{
				$("#bloqueada").attr("checked", true);
			} else {
				$("#bloqueada").attr("checked", false);
			}
				
		}});
	}
	
	//Grid de búsqueda como relacionado a la cuenta
	function consultaRelacionadoCuenta(nombreCliente){
		var params = {};			
		params['tipoLista'] = 8;
		params['nombreCompleto'] = nombreCliente;
		if (nombreCompleto != ''){
			$.post("cuentasPersonaReqSeidoGrid.htm", params, function(dat){	
				if(dat.length > 0) {
					$('#gridRelacionadosCuenta').html(dat);
					$('#gridRelacionadosCuenta').show();
					habilitaBoton('imprimir');
				}else{	
					$('#gridRelacionadosCuenta').html("");
					$('#gridRelacionadosCuenta').show();
				}
			});
		}		
	}

	//Grid de búsqueda como relacionado a Inversiones
	function consultaRelacionadoInversiones(nombreCliente){
		var params = {};			
		params['tipoLista'] = 3;
		params['nombreCompleto'] = nombreCliente;
		if (nombreCompleto != ''){
			$.post("relacionadoInversionReqSeidoGrid.htm", params, function(dat){		
				if(dat.length > 0) { 
					$('#gridRelacionadosInversion').html(dat);
					$('#gridRelacionadosInversion').show();
					habilitaBoton('imprimir');
				}else{	
					$('#gridRelacionadosInversion').html("");
					$('#gridRelacionadosInversion').show();
				}
			});
		}		
	}

	//Grid de búsqueda como Aval
	function consultaRelacionadoAvales(nombreCliente){
		var params = {};			
		params['tipoLista'] = 2;
		params['nombreCompleto'] = nombreCliente;
		if (nombreCompleto != ''){
			$.post("relacionadoCredAval.htm", params, function(dat){	
				if(dat.length > 0) { 
					$('#gridCreAvales').html(dat);
					$('#gridCreAvales').show();
					habilitaBoton('imprimir');
				}else{
					$('#gridCreAvales').html("");
					$('#gridCreAvales').show();
				}
			});
		}		
	}
	
	//Grid de búsqueda como Cliente
	function consultaRelacionadoCliente(nombreCliente,clienteID){
		if(clienteID == ''){
			clienteID = 0;
		}
		var params = {};			
		params['tipoLista'] = 37;
		params['nombreCompleto'] = nombreCliente;
		params['clienteID']= clienteID;
		if (nombreCompleto != ''){
			$.post("clientePersonaReqSeidoGrid.htm", params, function(dat){	
				if(dat.length > 0) { 					
					$('#gridClientes').html(dat);
					$('#gridClientes').show();
					habilitaBoton('imprimir');
				}else{		
					$('#gridClientes').html("");
					$('#gridClientes').show();
				}
			});
		}		
	}
	
	function funcionExito(){	
		consultaRelacionadoCuenta($('#nombreCompleto').val());		
		consultaRelacionadoInversiones($('#nombreCompleto').val());
		consultaRelacionadoAvales($('#nombreCompleto').val());	
		consultaRelacionadoCliente($('#nombreCompleto').val(), $('#clienteID').val());
		$('#imprimir').focus();
//--------------DEVOLVER EL FOCO A BOTON BUSCAR
		$('#mensaje').html(function(){
			$('#nombreControl').val("buscarcli")
		});
	}
	
	function funcionFallo(){
		
	}