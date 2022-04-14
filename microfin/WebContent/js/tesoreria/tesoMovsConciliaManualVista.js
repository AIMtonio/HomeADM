$(document).ready(function() {
    esTab = true;
    varFechasDiferentes = 1;
    valorFechaOperacion = '';
    existenMovsSelec = 0;
    $('#institucionID').focus();
    //Definicion de Constantes y Enums  
    var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};
    
    var catTipoTransaccionInstituciones = {
      		'principal':1, 
      		'cierre':2
    };
    
    var catTipoConsultaCentro = { 
	  		'principal'	: 1,
	  		'foranea'	: 2
		};
 
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	//limpiarCampos();
	
	$(':text').focus(function() {	
		esTab = false;
	});
        
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	deshabilitaBoton('guardar');
	
	$.validator.setDefaults({
		submitHandler: function(event) {			
			if($('#tipoTransaccion').val()==catTipoTransaccionInstituciones.principal){
				
				if(validaTiposMovs()!=0 ){
					if (validaCentCost()==0) {
						$('#existenMovsSelec').val(existenMovsSelec);					
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'polizaID',
							'funcionExitoConciliacionManual', 'funcionErroConciliacionManual');
					}else{
						mensajeSis('Seleccione un Centro de Costos');
						$("#cCostos"+validaCentCost()).focus();
					}								
				}else{
					alert("Seleccione al menos un Movimiento para Conciliar.");
				}
			}else if($('#tipoTransaccion').val()==catTipoTransaccionInstituciones.cierre){
				
				if(validaSeleccionados()){
					$('#existenMovsSelec').val(existenMovsSelec);

					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'polizaID',
							'funcionExitoConciliacionManualCerrar', 'funcionErroConciliacionManualCerrar');					
				}else{
					alert("No se han encontrado Conciliaciones Seleccionadas.");
				}
			}
			
    	}
    });
	
	$('#guardar').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionInstituciones.principal);
	});
	
	$('#cerrar').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionInstituciones.cierre);
	});
	
	$('#institucionID').bind('keyup',function(e){
    	lista('institucionID', '1', '1', 'nombre',$('#institucionID').val(), 'listaInstituciones.htm');
    });
	
    $('#institucionID').blur(function() {
    	$('#fechaSistema').val(parametroBean.fechaSucursal); 
    	habilitaBoton('guardar');
    	$('#impPoliza').hide();
    	if($('#institucionID').val() != '' && !isNaN($('#institucionID').val()) ){
    		consultaInstitucion(this.id);
    	}else{
			//limpiarCampos();
			$('#numCtaInstit').val("");
			$('#nombreInstitucion').val("");
    	}
    	
    });
    //Imprimi la poliza
	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();	 
		var fecha = parametroBean.fechaSucursal;	
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);
	});	
    
    $('#numCtaInstit').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
                        
		camposLista[1] = "cuentaAhoID";			
		parametrosLista[1] = $('#numCtaInstit').val();
                    
		lista('numCtaInstit', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
    });
    
    $('#numCtaInstit').blur(function() {
    	$('#fechaseleccionada').val('');
    	$('#segfechaseleccionada').val('');
    	varFechasDiferentes = 1;
    	$('#impPoliza').hide();
    	if($('#numCtaInstit').val() != '' && !isNaN($('#numCtaInstit').val()) ){
    		consultaCuentaBan(this.id);	
    	}
    });
   
   
    
    //------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			numCtaInstit: 'required'			
		},		
		messages: {
			institucionID: 'Especifique la Institución',
			numCtaInstit: 'Especifique el Número de Cuenta'
		}
	});
	
	// funciones
	//Método de consulta de Institución
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var institutoBeanCon = {
  				'institucionID':numInstituto
				};
		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, institutoBeanCon, function(instituto){
				if(instituto!=null){							
					$('#nombreInstitucion').val(instituto.nombre);		
					$('#numCtaInstit').val("");
					$('#gridMovsConciliacionManual').hide();
				}else{
					alert("No Existe la Institución"); 
					$('#gridMovsConciliacionManual').hide();
					$('#numCtaInstit').val('');
					$(jqInstituto).focus();
					$(jqInstituto).select();
				}    						
			});
		}else{
			$('#numCtaInstit').val("");
			$('#nombreInstitucion').val("");
		}
	}
	
	// Método para consultar la cuenta bancaria
	function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		
		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': numCuenta
		};
					
		operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
			if(data!=null){
				consultaMovimientosNoConciliados();
			}else{
				alert("La Cuenta Indicada no esta Asociada con la Institución");
				$(jqCuentaBan).focus();
				$(jqCuentaBan).select();
				$('#gridMovsConciliacionManual').hide();
			}
		});
	}
	
	// función para mostrar el grid con los movimientos de tesoreria no conciliados
	function consultaMovimientosNoConciliados(){
		
		var params = {};
		params['tipoLista'] = 1;
		params['institucionID'] = $('#institucionID').val();
		params['numCtaInstit'] = $('#numCtaInstit').val();

		$.post("conciliacionManualGridVista.htm", params, function(data){
			$('#gridMovsConciliacionManual').show();
				if(data.length >0) {
					$('#gridMovsConciliacionManual').html(data);
					$('#gridMovsConciliacionManual').show();					
					comboTiposMovTesoConciliacion();
				}else{
					$('#gridMovsConciliacionManual').html("");
					$('#gridMovsConciliacionManual').show();
				}
				
		});
	}
     
	// funcion para llenar el combo de tipo Movimiento del gridMovsConciliacionManual
    function comboTiposMovTesoConciliacion() {	
    	var tiposMovTesoBean = {
			'descripcion':'',
			'tipoMovimiento':''
		};
    	TiposMovTesoServicioScript.listaCombo(2, tiposMovTesoBean, function(tiposMovTeso){
    		$('select[name=listaTipoMov]').each(function() { 
				jqTipoMovID = eval("'" + this.id + "'");
				dwr.util.removeAllOptions(jqTipoMovID);
				dwr.util.addOptions(jqTipoMovID, {'':'SELECCIONAR'}); 
				dwr.util.addOptions(jqTipoMovID, tiposMovTeso, 'tipoMovTesoID', 'descripcion'); 
				
			});
    	});
    	$('#fechaSistema').val(parametroBean.fechaSucursal);  
	}

});

// Funcion para limpiar los campos de la pantalla 
function limpiarCampos(){ 
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	$('#gridMovsConciliacionManual').html("");          
	$('#fechaSistema').val(parametroBean.fechaSucursal);  
	deshabilitaBoton('guardar','submit');
	$('#cerrar').hide(200);
}

function consultaForaneaTiposMov(idControl,num) {
	var jqCtaConcepto = eval("'#" + idControl + "'");
	var jqCtaMay = eval("'#cuentaMayor" + num + "'");
	var jqCtaCon = eval("'#cuentaContable" + num + "'");
	var jqCtaCon1 = eval("'#cuentaContableNoEdit" + num + "'");
	var jqCtaCo  = eval("'#cuentaCon" + num + "'");
	var jqtdNoEdit = eval("'#tdNoEdiCtaCon" + num + "'");
	var jqtdEdit  = eval("'#tdEdiCtaCon" + num + "'");
	var jqtdEdit2  = eval("'#tdEdiCtaConEditable" + num + "'");
	var jqNaturaMov  = eval("'#natMovimiento" + num + "'");
	var jqtipoMov = eval("'#tipoMov" + num + "'");
	var numConcepto = $(jqCtaConcepto).val();
	// var e = document.getElementById("ddlViewBy");
	var tesoMovTipoBean = {
			'tipoMovTesoID':numConcepto,
	};
	setTimeout("$('#cajaLista').hide();", 200);
	
	if(validaTiposMovs()==0){
	    varFechasDiferentes = 1;
	    valorFechaOperacion = '';
		$(jqCtaCo).val("");
		$(jqCtaCon1).val("");
		$(jqCtaCon).val("");	
		$(jqCtaMay).val("");
		existenMovsSelec = 0;
	}else{
		if(numConcepto != '' && !isNaN(numConcepto) ){
			
				TiposMovTesoServicioScript.conTiposMovTeso(2,tesoMovTipoBean,function(tipoBean){
				
					if(tipoBean!=null){ 
						if($(jqNaturaMov).val()==tipoBean.naturaContable ){
							if(tipoBean.cuentaEditable=="S"){
								$(jqtdEdit).show();
								$(jqtdEdit2).show();
								$(jqtdNoEdit).hide();
								$(jqCtaMay).val(tipoBean.cuentaMayor);
								var longitud=tipoBean.cuentaMayor.toString().length;
								$(jqCtaCo).val(tipoBean.cuentaContable.substr(longitud,25));
								$(jqCtaCon1).val(tipoBean.cuentaMayor+tipoBean.cuentaContable.substr(longitud,25));
								$(jqCtaCon).val(tipoBean.cuentaMayor+tipoBean.cuentaContable.substr(longitud,25));
					
								
							}else{
								if(tipoBean.cuentaEditable=="N"){
									$(jqtdEdit).hide();
									$(jqtdEdit2).hide();
									$(jqtdNoEdit).show();
									$(jqCtaCon).val(tipoBean.cuentaContable);
									$(jqCtaCon1).val(tipoBean.cuentaContable);
								}
							}
							existenMovsSelec = 0;
						}else{
							alert("Seleccione el tipo de Movimiento Correcto ");
							$(jqtipoMov).val(0).selected = true;
							$(jqCtaCo).val("");
							$(jqCtaCon1).val("");
							$(jqCtaCon).val("");	
							$(jqCtaMay).val("");
							existenMovsSelec = 0;
						}
					} else{
						alert("No Existe el Tipo de Movimiento.");
						$('#tipoMovTesoID').val(""); 
						$(jqtipoMov).val(0).selected = true;
						$(jqCtaCo).val("");
						$(jqCtaCon1).val("");
						$(jqCtaCon).val("");			
						$(jqCtaMay).val("");		
						existenMovsSelec = 0;
					}
				}); 
			}
		
		else{
			$(jqCtaCo).val("");
			$(jqCtaCon1).val("");
			$(jqCtaCon).val("");	
			$(jqCtaMay).val("");
			existenMovsSelec = 0;
		}
	}	
}

//Funcion para validar si existe un Centro de Costos de movimientos seleccionados
function validaCentCost(){
	centroCostoFalta = 0;
	numElementos = 1;
	if (validaTiposMovs!=0){
		$('select[name=listaTipoMov]').each(function(){
			if(!(this.value === "")){
				idCCost = "cCostos"+numElementos;
				if($("#"+idCCost)[0].value === ""){
					centroCostoFalta = (centroCostoFalta!=0) ? centroCostoFalta : numElementos;
				}
			}
			numElementos ++;
		});
	}
	return centroCostoFalta;
}


// funcion para validar si hay algun tipo de movimiento seleccionado
function validaTiposMovs() {
    existenMovsSelec = 0;
      $('select[name=listaTipoMov]').each(function() { 
	  jqTipoMovID = eval("'#" + this.id + "'");
	  //tipoMovTesoDes=("'#" + this.id + "option:selected'").text();
	  if($(jqTipoMovID).asNumber() >0){
		  existenMovsSelec ++;
	    if(existenMovsSelec==1){
	      $('#tipoMovTesoDes').val($(jqTipoMovID+" option:selected").text().toUpperCase());
	    }else{
	      $('#tipoMovTesoDes').val('');
	    }
	  }
      });
      return existenMovsSelec;
}
 

function validaCuentaContable(num) {
	
	$('select[name=listaTipoMov]').each(function() { 
		jqTipoMovID = eval("#" + this.id + "'");
		dwr.util.removeAllOptions(jqTipoMovID);
		dwr.util.addOptions(jqTipoMovID, {'':'SELECCIONAR'}); 
		dwr.util.addOptions(jqTipoMovID, tiposMovTeso, 'tipoMovTesoID', 'descripcion'); 
		habilitaBoton('guardar','submit');
	});
}
 

var varFechasDiferentes = 1;
var valorFechaOperacion = '';
var diferentesFechas = 1;
var existenMovsSelec = 0;
var tipoMovTesoDes='';


// funcion para validar que se seleccionen movimientos de la misma fecha
function validaFechaMovSeleccionado(idControl, numero) {
	jqTipoMovID = eval("'" + idControl + "'");
	var jqtipoMov = eval("'#tipoMov" + numero + "'");
	if($(jqTipoMovID).val()!= ''){
		jqFechaOpera = eval("'#fechaOperacion" + numero+ "'");			
		var jqCtaMay = eval("'#cuentaMayor" + numero + "'");
		var jqCtaCon = eval("'#cuentaContable" + numero + "'");
		var jqCtaCon1 = eval("'#cuentaContableNoEdit" + numero + "'");
		var jqCtaCo  = eval("'#cuentaCon" + numero + "'");	
		if(varFechasDiferentes == 1){
			valorFechaOperacion = $(jqFechaOpera).val();
			$('#fechaseleccionada').val(valorFechaOperacion);
			varFechasDiferentes=2;
			consultaForaneaTiposMov(idControl,numero);
		}else{
			
			if(varFechasDiferentes== 2){
			
				var valorFechaOperacion2 = $(jqFechaOpera).val();
				$('#segfechaseleccionada').val(valorFechaOperacion2);
			
				if(	$('#fechaseleccionada').val() != ''){ 
				if($('#fechaseleccionada').val() == $('#segfechaseleccionada').val()) {
					consultaForaneaTiposMov(idControl,numero);
				
				}
				else{
					alert("Asegurese de seleccionar Movimientos con la misma Fecha.");
					existenMovsSelec = 0;
					$(jqtipoMov).val(0).selected = true;
					$(jqCtaCo).val("");
					$(jqCtaCon1).val("");
					$(jqCtaCon).val("");	
					$(jqCtaMay).val("");
					varFechasDiferentes = 2;
					diferentesFechas = 0;

					
				}
			}
			
			}
		}
		
	}

}

function listaMaestroCuentas(numero){
	var jq = eval("'#cuentaCon" + numero + "'");
	var jqCtaMay = eval("'#cuentaMayor" + numero + "'");
	var jqCta = eval("'#cuentaContable" + numero + "'");
	
	$(jq).bind('keyup',function(e){
		var num =  $(jqCtaMay).val()+$(jq).val();
			
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "descripcion"; 
		parametrosLista[0] = num;
		listaAlfanumerica('cuentaCon' + numero, '0', '4', camposLista, parametrosLista, 'listaCuentasContables.htm');
		$(jqCta).val($(jqCtaMay).val()+$(jq).val());
	});
}	

function ocultarLista(numero){
	setTimeout("$('#cajaLista').hide();", 200);	
	var jq = eval("'#cuentaCon" + numero + "'");
	var jqCtaMay = eval("'#cuentaMayor" + numero + "'");
	var jqCta = eval("'#cuentaContable" + numero + "'");
	$(jqCta).val($(jqCtaMay).val()+$(jq).val());	
}

// funcion para mostrar lista de centro de costos
function listaCentroCostos(numero){
	var jq = eval( "'#cCostos" + numero + "'");		
		
    $(jq).bind('keyup',function(e){			
		var num = $(jq).val();				
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "descripcion"; 
		parametrosLista[0] = num;	
		lista('cCostos' + numero, '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	});
    }

// funcion para consultar centro de costos 
function consultaCentroCostos(control) {
	var jqCentroCostos = $('#'+ control).val();
	setTimeout("$('#cajaLista').hide();", 200);	
	var CentroCostoBeanCon = {
				'centroCostoID':jqCentroCostos
	};
	if(jqCentroCostos!=''){
		if(jqCentroCostos>0 ){
			centroServicio.consulta(1,CentroCostoBeanCon,function(centro) {
				if(centro!=null){																
				}else{
					alert("El centro de Costos no Existe"); 
					$('#'+ control).val('');
					$('#'+ control).focus();
					console.log($('#'+ control).focus());
				}    						
			});
		}else{
			//alert("Solo números"); 
			$('#'+ control).val('');
			$('#'+ control).focus();
		}
	}
		
		
}

function validaSeleccionados(){
	$('#listaFoliosCarga').val('');
	var alerta=0;
	$('input[name=check]').each(function(){
		var ID = this.id.substring(5);

		var jqCheck = eval("'#"+this.id+"'");
		var jqfolioCarga = eval("'#folioCargaID"+ID+"'");
		
		if($(jqCheck).is(':checked')){
			$('#listaFoliosCarga').val($('#listaFoliosCarga').val()+","+$(jqfolioCarga).val());
			alerta=1;			
		}		
	});
	if(alerta==0){
		alert("No se ha Seleccionado Ninguna Conciliación");
		return false;
	}else if(alerta==1){
		$('#listaFoliosCarga').val($('#listaFoliosCarga').val().substring(1));	
		return true;
	}
	return false;
}



function funcionExitoConciliacionManual(){
	$('#impPoliza').show();
	deshabilitaBoton('guardar','submit');
}

function funcionErroConciliacionManual(){
	$('#impPoliza').hide();
}




function funcionExitoConciliacionManualCerrar(){
	deshabilitaBoton('guardar','submit');
}

function funcionErroConciliacionManualCerrar(){
	$('#impPoliza').hide();
}