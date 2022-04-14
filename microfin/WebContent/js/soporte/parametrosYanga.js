$(document).ready(function() {
	//en caso de necesitar valores de seion 
	//parametros = consultaParametrosSession();
	var catTipoTransaccionParametros = {
		'modificacion' : '1'			
	};	
	esTab = true;
	
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	
	/*esta funcion esta en forma.js */
	deshabilitaBoton('modificar', 'submit');
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	consultaTiposCuenta();
	
	/*esta funcion esta en forma.js, verifica que el mensaje d erro o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','empresaID',
	    			'funcionExitoParamYanga','funcionFalloParamYanga'); 
	      }
	 });
	
	/*asigna el tipo de transaccion */
	$('#modificar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionParametros.modificacion);
	});
	
	
	/*busca y lista las empresas */
	$('#empresaID').bind('keyup',function(e){	
		if(this.value.length >= 2){ 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista,parametrosLista, 'listaParametrosSis.htm');	
		}
	});
	
	$('#empresaID').blur(function() {
		validaEmpresaID(this);
	});
	
	
	
	/*busca y lista los tipos de cuentas contables */
	$('#haberExSocios').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#haberExSocios').val();
			lista('haberExSocios', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	/*obtiene la descripcion de la cuenta contable seleccionada */
	$('#haberExSocios').blur(function() {
		maestroCuentasDescripcion(this.id,'haberExSociosDes','haberExSocios');
	});


	
	$('#ctaProtecCta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaProtecCta').val();
			lista('ctaProtecCta', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaProtecCta').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaProtecCtaDes','ctaProtecCta');
	});

	
	$('#ctaProtecCre').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaProtecCre').val();
			lista('ctaProtecCre', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaProtecCre').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaProtecCreDes','ctaProtecCre');
	});

	
	$('#ctaContaPROFUN').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContaPROFUN').val();
			lista('ctaContaPROFUN', '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	$('#ctaContaPROFUN').blur(function() {
		maestroCuentasDescripcion(this.id,'ctaContaPROFUNDes','ctaContaPROFUN');
	});



	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {			
				empresaID: {
					required: true,
					minlength: 1,
					number: true
				},	
				tipoCtaProtec:{
					required: true,
					number: true
				},
				montoMaxProtec:{
					required: true,
					number: true
				},
				montoPROFUN:{
					required: true,
					number: true
				},
				aporteMaxPROFUN:{
					required: true,
					number: true
				}
			},		
			messages: {
				empresaID: {
					required: 'Especificar la empresa',
					minlength: 'Al menos 1 Caracter',
					number: 'solo números'
				},
				haberExSocios: {
					required: 'Especificar cuenta',
					number: 'solo números'
				},
				tipoCtaProtec: {
					required: 'Especificar tipo de cuenta',
					number: 'solo números'
				},
				montoMaxProtec: {
					required: 'Especificar monto máximo',
					number: 'solo números'
				},
				ctaProtecCta: {
					required: 'Especificar cuenta',
					number: 'solo números'
				},
				montoPROFUN: {
					required: 'Especificar monto',
					number: 'solo números'
				},
				aporteMaxPROFUN: {
					required: 'Especificar monto máximo',
					number: 'solo números'
				},
				ctaContaPROFUN: {
					required: 'Especificar cuenta',
					number: 'solo números'
				}
				,
				ctaProtecCre: {
					required: 'Especificar cuenta',
					number: 'solo números'
				}
			}		
		});
			
		
		
		
/* =================== FUNCIONES ========================= */
	
	/*consulta los datos de la empresa, si la escuentra presenta los datos en la vista */
	function validaEmpresaID(control) {
		var numEmpresaID = $('#empresaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoCon = 1;
		var ParametrosYangaBean = {
				'empresaID'	:numEmpresaID
		};
		if (numEmpresaID != '' && !isNaN(numEmpresaID)) {
			if (numEmpresaID == '0') {			
				deshabilitaBoton('modificar', 'submit');
				inicializaForma('formaGenerica', 'empresaID');
				$('#tipoCtaProtec').val("0").selected = true;
			} else {								
				habilitaBoton('modificar', 'submit');
				parametrosYangaServicio.consulta(tipoCon,ParametrosYangaBean,function(parametrosYangaBean) {
					if (parametrosYangaBean != null) {
						dwr.util.setValues(parametrosYangaBean);
						consultaCuenta('tipoCuenta');
						maestroCuentasDescripcion('haberExSocios','haberExSociosDes');
						maestroCuentasDescripcion('ctaProtecCta','ctaProtecCtaDes');
						maestroCuentasDescripcion('ctaProtecCre','ctaProtecCreDes');
						maestroCuentasDescripcion('ctaContaPROFUN','ctaContaPROFUNDes');
					}
					else {
						limpiaForm($('#formaGenerica'));						
						deshabilitaBoton('modificar','submit');						
						$('#empresaID').focus();
						$('#empresaID').select();
						$('#tipoCtaProtec').val("0").selected = true;
					}
				});
			}//else
		}//if
		 else {
				limpiaForm($('#formaGenerica'));						
				deshabilitaBoton('modificar','submit');						
				$('#empresaID').focus();
				$('#empresaID').select();
				$('#tipoCtaProtec').val("0").selected = true;
			}
	}//validaEmpresaID
	
	
	/*selecciona en el combo el tipo que tenga registrada la empresa*/
	function consultaCuenta(idControl) {
		var jqCuenta = eval("'#" + idControl + "'");
		var numCta = $(jqCuenta).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var TipoCuentaBeanCon = {
				'tipoCuentaID':numCta	};								
		if(numCta != '' && !isNaN(numCta)){												
			tiposCuentaServicio.consulta(catTipoConsultaTipoCuenta.foranea, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){									
					$('#descripcion').val(tipoCuenta.descripcion);																
				}else{
					alert("No existe la cuenta"); 
					$('#tipoCuenta').val('');	
					$('#tipoCuenta').focus();	
					$('#descripcion').val("");					
				}     						
		});
		}
	}
			  			
    /*consulta los tipos de cuentas y las agrega al combo */
		function consultaTiposCuenta() {	
			var bean={};
			dwr.util.removeAllOptions('tipoCtaProtec'); 
			dwr.util.addOptions('tipoCtaProtec', {'':'SELECCIONAR'}); 
			tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
				dwr.util.addOptions('tipoCtaProtec', tiposCuenta, 'tipoCuentaID', 'descripcion');
			});
			}
		
		
		/* consulta el no. de cuenta y agrega su descripcion al campo correspondiente */
		function maestroCuentasDescripcion(idControl,campoDescripcion,otraCuentaContable){ 		
			var jqCtaContable = eval("'#" + idControl + "'");
			var numCtaContable =  $(jqCtaContable).val(); 
			var conForanea = 2;
			var CtaContableBeanCon = {
					'cuentaCompleta':numCtaContable
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCtaContable != '' && !isNaN(numCtaContable)){
				cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
					if(ctaConta!=null){
						
						if(ctaConta.grupo != "E"){
							$('#'+campoDescripcion).val(ctaConta.descripcion);	
						} 
						else{
							alert("Sólo Cuentas Contables De Detalle");
							$(jqCtaContable).val("");
							$('#'+campoDescripcion).val('');
							$(jqCtaContable).focus();		
						}
					}
					else{
						alert("No existe la cuenta contable");
                        $(jqCtaContable).val(''); 
						$('#'+campoDescripcion).val('');
						$(jqCtaContable).focus();
					}
				}); 
			}
		
		}	
		
		
		
	});






/*funcion que se ejecuta cuando la operacion fue un exito */
function funcionExitoParamYanga(){
	inicializaForma('formaGenerica','empresaID');
	$('#tipoCtaProtec').val("0").selected = true;
}

/*funcion que se ejecuta cuando la operacion fue un fallo */
function funcionFalloParamYanga (){}
			