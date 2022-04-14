$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();      
	var fechaSucursal = parametroBean.fechaSucursal;
	var var_clienteSocio = $("#clienteSocio").val(); 	// Guarda si el sistema maneja Clientes o Socios
	var instCrediclub = 'CREDICLUB';
	var catTipoGeneracion= {
			'mensual'	:	'M',
			'semestral'	:	'S'
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('consultar', 'submit');
	
	// Consulta la Empresa
	validaEmpresaID();

	// Consulta de Institucion parametrizada en 
	// sistema para desplegar campos correctos
	consultaInstitucion();
   
   $(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	


   $('#numeroTarjeta').bind('keypress', function(e){
		return validaAlfanumerico(e,this);		
	});
   
	$('#numeroTarjeta').blur(function(e){
		var longitudTarjeta=$('#numeroTarjeta').val().length; 
		if (longitudTarjeta<16){
			$('#numeroTarjeta').val("");
		}else{
			consultaClienteIDTarDeb('numeroTarjeta');	
		}
	});
	
   // Consulta del Cliente
	$('#clienteID').blur(function(){
		if (this.value != '' && Number(this.value) > 0 && !isNaN(this.value)) {
			if(esTab){
				consultaClientePantalla(this.id);
			}
		} else {
				inicializaValoresPantalla();	
			}			
	});

	// Lista de Clientes
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	// Genera en PDF el Estado de Cuenta del Cliente
	$('#consultar').click(function() { 
		generaEstadoCuentaPDF();
	});
	
	$('#tipoGeneracionM').click(function() {
		$('#tipoGeneracion').val(catTipoGeneracion.mensual);
		$('#tipoGeneracionM').focus();
	});
	$('#tipoGeneracionS').click(function() {
		$('#tipoGeneracion').val(catTipoGeneracion.semestral);
		$('#tipoGeneracionS').focus();
	});
	
	$('#tipoGeneracionM').change(function() {
		$('#tipoGeneracion').val(catTipoGeneracion.mensual);
		llenaComboPeriodoMeses();
	});
	$('#tipoGeneracionS').change(function() {
		llenaComboPeriodoSemestres();
		$('#tipoGeneracion').val(catTipoGeneracion.semestral);
	});

	
	//------------ Validaciones de Controles -------------------------------------
	
	//------------ VALIDACIONES DE LA FORMA -------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			}
		},		
		messages: {
			clienteID: {
				required: 'Especifique Número de '+ var_clienteSocio + ''
			}
		}
	});
	
	//Función para poder ingresar solo números o letras 
	function validaAlfanumerico(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
			key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
				key = e.which;
		}
		 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
		    return false;
		 var longitudTarjeta=$('#numeroTarjeta').val().length;		 	
		 		if (longitudTarjeta == 16 ){
					consultaClienteIDTarDeb('numeroTarjeta');							
				}	
		 return true;	 
	}
	
	// Función que valida la Empresa
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,{ async: false, callback: function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			if(parametrosSisBean.servReactivaCliID !=null){
				 if(parametrosSisBean.tarjetaIdentiSocio=="S"){
						$('#tarjetaIdentiCA').show();
						$('#numeroTarjeta').val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$("#numeroTarjeta").focus();
					}else{
						$("#clienteID").focus();
						$('#tarjetaIdentiCA').hide();
						$('#numeroTarjeta').val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
					}
				}else{
					
				}
			}}
		});
	}
  
	// Función que consulta los meses anteriores
	function consultaMesesAnteriores() {
		var mesArray = new Array(
								"Enero","Febrero","Marzo","Abril","Mayo","Junio",
                			"Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre");
      
 
		var mesActual = parseInt(fechaSucursal.substr(5,2) )-1;
		var AnioActual = parseInt(fechaSucursal.substr(0,4));
		var AnioOriginal = AnioActual;
		if(mesActual<=0){
			AnioActual	= AnioActual-1;
		}
      var mesAnterior = mesActual;
		for( var i=-3; i<0; i++){
			mesAnterior = mesActual + i;
  			if(mesAnterior<0){
  				mesAnterior = mesAnterior +12;
				if(AnioOriginal == AnioActual){
  					AnioActual = AnioActual -1;
  				}
  			}else{
  				AnioActual = AnioOriginal;
  			}
 			$('#periodo').append('<option value="' + String(AnioActual) +
 										 completaCerosIzq(String(mesAnterior+1),2) + '">' +
 										 mesArray[mesAnterior] + "-" + String(AnioActual) + '</option>');
  		}
  		$('#periodo option:last-child').attr("selected",true);		
	}
  
	// Función que consulta el Cliente
	function consultaClientePantalla(idControl) { 
		var jqCliente  = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		var personaFisica = 'F';
		var personaFiAct = 'A';
		var personaMoral = 'M';
		var estatusInactivo = 'I';
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(varclienteID != '' && !isNaN(varclienteID)){
			clienteServicio.consulta(conCliente,varclienteID,rfc,{ async: false, callback: function(cliente){
				if(cliente!=null){		
					$('#clienteID').val(cliente.numero);
					$('#sucursalOrigen').val(cliente.sucursalOrigen);
					var tipo = (cliente.tipoPersona);
					if(tipo == personaFiAct){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo == personaFisica){
						$('#nombreCliente').val(cliente.nombreCompleto);
					}
					if(tipo == personaMoral){
						$('#nombreCliente').val(cliente.razonSocial);
					}	

	        		$('#periodo').focus();
	        		habilitaBoton('consultar', 'submit');
	        		
					if (cliente.estatus== estatusInactivo){
						deshabilitaBoton('consultar','submit');
						
						mensajeSis("El Cliente se encuentra Inactivo");
						$('#nombreCliente').val('');
						$('#clienteID').select();
						$('#clienteID').focus();
						
					}

				}else{
					mensajeSis("No Existe el Cliente");
					$('#nombreCliente').val('');
					$(jqCliente).select();
					$(jqCliente).focus();
					$(jqCliente).val('');
					deshabilitaBoton('consultar','submit');
					
				}  
			}});
		}
	}
	
	// Función completa Ceros
	function completaCerosIzq(obj,longitud) {
		var numtmp= String(obj);
  		while (numtmp.length<longitud){  		
    		numtmp = '0'+numtmp;
		}
		return numtmp;
	}	
	

	// Función que consulta el Número de Tarjeta
	function consultaClienteIDTarDeb(control){
		var jqControl=	eval("'#" + control + "'");
		var numeroTar=$(jqControl).val();
		var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
			numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
			numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
			numeroTar=numTarIdenAccess;
			
		$(jqControl).val(numeroTar);
		var conNumTarjeta=20;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numeroTar
			};
		
		if(numeroTar != '' && numeroTar > 0){
			if ($(jqControl).val().length>16){
				mensajeSis("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if($(jqControl).val().length == 16){
				tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
					if(tarjetaDebito!=null){					
						if (tarjetaDebito.estatusId==7){
							$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
							$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
							
							if ($('#numeroTarjeta').val()!=""&& $('#idCtePorTarjeta').val()!=""){
							$('#clienteID').val($('#idCtePorTarjeta').val());
							esTab=true;
							consultaClientePantalla('clienteID');
							}
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
						}else{
								if (tarjetaDebito.estatusId==1){
									mensajeSis("La Tarjeta no se Encuentra Asociada a una Cuenta");
								}else
								if (tarjetaDebito.estatusId==6){
									mensajeSis("La Tarjeta no se Encuentra Activa");
								}else
								if (tarjetaDebito.estatusId==8){
									mensajeSis("La Tarjeta se Encuentra Bloqueada");
								}else
								if (tarjetaDebito.estatusId==9){
									mensajeSis("La Tarjeta se Encuentra Cancelada");
								}
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#nombreCliente').val('');
								$('#clienteID').val("");
								deshabilitaBoton('consultar','button');
						}
					}else{
						mensajeSis("La Tarjeta de Identificación no existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$('#nombreCliente').val('');
						$('#clienteID').val("");
						deshabilitaBoton('consultar','button');
					}
					});
				}
			}
		 }
	
	// Función para consultar el estado de cuenta del cliente en formato PDF
	function generaEstadoCuentaPDF() {	
		var clienteID =$('#clienteID').val();
		var periodo =$('#periodo').val();
		var sucursalOrigen =$('#sucursalOrigen').val();

		var pagina='consultaEdoCuentaRep.htm?clienteID='+clienteID +'&periodo='+periodo+
					'&sucursalOrigen='+sucursalOrigen;
					window.open(pagina, '_blank');

									
		
		}
	
	// Consulta el tipo de institucion
	function consultaInstitucion() {			
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(10,parametrosSisCon, function(parametros) {
			if (parametros != null) {
				nombreCortoInstitucion = parametros.nombreCortoInst;
				if(nombreCortoInstitucion == instCrediclub){
					llenaComboPeriodoMeses();
					$('#opcionesTipoGeneracion').show();
				}else{
					consultaMesesAnteriores();
					$('#opcionesTipoGeneracion').hide();
				}
			}
		});
	}
});

//Inicializa los valores de la pantalla (selecciona los valores por default en algunos campos) 
function inicializaValoresPantalla(){
	inicializaForma('formaGenerica','clienteID');
	deshabilitaBoton('consultar', 'submit');
	$('#clienteID').val('');
	$('#nombreCliente').val('');
}

function llenaComboPeriodoMeses(){
	dwr.util.removeAllOptions('periodo'); 
	edoCtaPeriodoEjecutadoServicio.listaCombo(1, function(beanLista){
		dwr.util.addOptions('periodo', beanLista, 'anioMes', 'periodo');
	});
}

function llenaComboPeriodoSemestres(){
	dwr.util.removeAllOptions('periodo'); 
	edoCtaPeriodoEjecutadoServicio.listaCombo(2, function(beanLista){
		dwr.util.addOptions('periodo', beanLista, 'anioMes', 'periodo');
	});
}

