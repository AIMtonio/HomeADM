	$(document).ready(function() {
		esTab = true;
		$('#tipoCedeID').focus();
	
		// Definicion de Constantes y Enums
		var catTipoTransaccionTasas = {
				'agrega' : 1,
				'modifica' : 2,
				'elimina' : 3
		};

		var catTipoListaTasas= {
				'principal':1,
				'secundaria':2,
				'tercera':3
		};
	
		var catTipoListaDias = {
			'combo':3
		};
		var catTipoListaMontos = {
			'combo':3
		};
	
		 
		// Definicion de Constantes y Enums
		var catTipoConsulta = {
				'principal' : 1,
				'dias': 2,
				'montos': 3,
				'comboBox' : 5
		};
		
		
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('eliminar', 'submit');
		
		ocultaInverionVariable();
		$(':text').focus(function() {	
		 	esTab = false;
		});
				
		$.validator.setDefaults({
			submitHandler: function(event) { 
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tasaCedeID','exitoTransaccionGrabar','falloTransaccionGrabar');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('eliminar', 'submit');
				}
		});
		
			
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
		
		$('#agrega').click(function(e) {		
			$('#tipoTransaccion').val(catTipoTransaccionTasas.agrega);
			agregaMontosPlazos();
			ValidaMontoPlazo(e);
			validaSucursales(e);
		
		});
		
		$('#modifica').click(function(e) {		
			$('#tipoTransaccion').val(catTipoTransaccionTasas.modifica);
			agregaMontosPlazos();
			ValidaMontoPlazo(e);
			validaSucursales(e);
		});
		
		$('#eliminar').click(function(e) {	
			$('#tipoTransaccion').val(catTipoTransaccionTasas.elimina);
			agregaMontosPlazos();
		});
		
		
		
		$('#todos').click(function(){
			var numero = 0;
			$('checkbox[name=seleccionar]').each(function() {
				numero= this.id.substr(11,this.id.length);			
				var seleccion=eval("'#seleccionar" + numero + "'");
				if ($('#todos').is(':checked')){
					$(seleccion).attr('checked',true);
				}else{
					$(seleccion).attr('checked',false);
				}
			});
			
		});
		
		$('#calculoInteres').change(function(){
			cambiaCalculoInteres();
		});
		
		
		
		$('#formaGenerica').validate({
			rules: {
				tasaFija: {
						required: function() { return $('#tasaFV').val()=='F';},

				},
				tipoCedeID:  		'required',
				tasaCedeID:			'required',
				tasaBase:	 {
						required: function() { return $('#tasaFV').val()=='V';},

				}
				
			},
			
			messages: {
				tasaFija: 		  'Especifique la Tasa Anualizada',
				tipoCedeID: 	  'Especifique Tipo de CEDES',
				tasaBase:		  'Especifique la Tasa.'
			}
			
		});
		
		$('#tasaCedeID').bind('keyup',function(e){	
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "descripcion";
			 parametrosLista[0] = $('#tasaCedeID').val();
			 camposLista[1] = "tipoCedeID";
			 parametrosLista[1] = $('#tipoCedeID').val();
			
			lista('tasaCedeID', 2, 1, camposLista,
					 parametrosLista, 'tasasCedesLista.htm');
		});

		
		$('#tipoCedeID').bind('keyup',function(e){	
			 var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "descripcion";
			 parametrosLista[0] = $('#tipoCedeID').val();
			
			lista('tipoCedeID', 2, 3, camposLista,
					 parametrosLista, 'listaTiposCedes.htm');
		});
			
		$('#tipoCedeID').blur(function() {
			if(esTab == true){				
				limpiaCamposSuc();
				if($('#tipoCedeID').val()==""){
				}
				validaTipoCede($('#tipoCedeID').val());		
				var tipocede = $('#tipoCedeID').val();
				var plazosBean = {
			  		'tipoCedeID':tipocede
				};
				var montosBean = {
			  		'tipoCedeID':tipocede
				};
				
				listarSucursales(0);
				if(!isNaN(tipocede) && tipocede != ''){
					dwr.util.removeAllOptions('plazoID');
					dwr.util.removeAllOptions('montoID');
					dwr.util.addOptions( "plazoID", {cero:'SELECCIONAR'});
					dwr.util.addOptions( "montoID", {cero:'SELECCIONAR'});
					$('#calificacion').val("");		
					plazosCedesServicio.listaCombo(catTipoListaDias.combo,plazosBean,function(dias){
							dwr.util.addOptions('plazoID', dias, 'plazosDescripcion', 'plazosDescripcion');
					});
								
					montosCedesServicio.listaCombo(catTipoListaMontos.combo,montosBean,function(montos){
							dwr.util.addOptions('montoID', montos, 'montosDescripcion', 'montosDescripcion');
					});		
					
				}
				if(isNaN($('#tipoCedeID').val()) ){
					$('#tipoCedeID').val("");
					$('#tipoCedeID').focus();
				}
		}
			
		});
			
	$('#tasaCedeID').blur(function(){
			if(esTab){
				limpiaCamposSuc();
				if($('#tasaCedeID').val()!='' && $('#tasaCedeID').val()!='0' && !isNaN($('#tasaCedeID').val())){
					consultaTasa(); 					
				}else{
					setTimeout("$('#cajaLista').hide();", 200);
					$('#tasaCedeID').val('0');
					listarSucursales(0);
					deshabilitaBoton('modifica','submit');
					deshabilitaBoton('eliminar', 'submit');
					var estatusTipoCed = $('#estatusTipoCede').val();
					if(estatusTipoCed == 'I'){
						deshabilitaBoton('agrega','submit');
						mensajeSis("El Producto "+$('#descripcionTipo').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#tipoCedeID').focus();
					}else{
						habilitaBoton('agrega','submit');
					}
					
					$('#calculoInteres').val(1);
					$('#descripcionTasaBaseID').val("");
					$('#calificacion').val("");	
					consultaGridTasas();
					$('#montoID').val("cero");
					$('#plazoID').val("cero");
					$('#tasaFija').val("");
				}	
			}
			
		});
		
		$('#tasaBase').bind('keyup',function(e){	
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombre";
			parametrosLista[0] = $('#tasaBase').val();						
			lista('tasaBase', '2', '1', camposLista, parametrosLista, 'tasaBaseLista.htm');			       
		});	
		
		
		$('#tasaBase').blur(function() {	
			if(esTab){
				if($('#tasaBase').val()!='' && $('#tasaBase').val()!='0' && !isNaN($('#tasaBase').val())){
				 		validaTasaBase(this.id);  	
			}	
			}
					 
		});
	
		
		function validaTasaBase(idControl){	
			var jqTasa  = eval("'#" + idControl + "'");
			var tasaBase = $(jqTasa).val();			
			var TasaBaseBeanCon = {
					'tasaBaseID':tasaBase
			};
			tasasBaseServicio.consulta(1,TasaBaseBeanCon ,function(tasasBaseBean) {
				if(tasasBaseBean!=null){
					$('#descripcionTasaBaseID').val(tasasBaseBean.nombre);
			
				}else{
					mensajeSis("No Existe la tasa base");
					$('#tasaBase').focus();
					$('#tasaBase').select();
					$('#calificacion').val("");	
				}
			});
		
		}
		
		/*Funcion para consultar el tipo de Cede*/
		function validaTipoCede(tipCede){
			$('#divGridSucursales').html("");
			$('#divGridSucursales').hide();
			var TipoCedeBean ={
				'tipoCedeID' :tipCede
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(tipCede != '' && !isNaN(tipCede) && esTab){
					tiposCedesServicio.consulta(catTipoConsulta.principal,TipoCedeBean, function(tipoCede){
						if(tipoCede!=null){
							
							$('#descripcionTipo').val(tipoCede.descripcion);	
							$('#tasaFV').val(tipoCede.tasaFV);	
							$('#estatusTipoCede').val(tipoCede.estatus);	
							
							if(tipoCede.tasaFV=='F'){
								ocultaInverionVariable();
							}else
							if(tipoCede.tasaFV=='V'){
								muestraInverionVariable();
							}						
							consultaGridTasas();
						}else{
							listarSucursales(0);
							inicializaForma('formaGenerica','tasaCedeID');
							deshabilitaBoton('modifica','submit');
							deshabilitaBoton('eliminar', 'submit');
							deshabilitaBoton('agrega','submit');
							$('#calculoInteres').val(1);
							$('#descripcionTasaBaseID').val("");
							$('#calificacion').val("N");
							$('#tasaCedeID').val("");
							$('#descripcionTipo').val("");
							$('#tipoCedeID').focus();
							mensajeSis("El Tipo de CEDES no Existe.");
							$('#montoID').val("cero");
							$('#plazoID').val("cero");
							$('#calificacion').val("");	
							$('#tasaFija').val("");
							$('#estatusTipoCede').val('');
						}
					});
				
			}				
		}
	
		function obtieneVariables(){
				var tasasInversionBean = {
						'tipoInvercionID' : $('#tipoInvercionID').val(),
						'diaInversionID' : $('#diaInversionID').val(),
						'montoInversionID' : $('#montoInversionID').val(),
						'tasaBaseID'	   : $('#tasaBase').val(),
						'calculoInteres'   : $('#calculoInteres').val()
		
				};
				return tasasInversionBean;
			}
			
			
			
			function ocultaInverionVariable(){
				$('#lblTasaBase').hide();
				$('#tasaBase').hide();
				$('#descripcionTasaBaseID').hide();
				$('#calculoInteres').hide();
				$('#lblCalculoInteres').hide();
				$('#lblSobreTasa').hide();
				$('#sobreTasa').hide();
				$('#lblPisoTasa').hide();
				$('#pisoTasa').hide();
				$('#lblTechoTasa').hide();
				$('#techoTasa').hide();
				$('#lblTasaAnualizada').show();
				$('#conceptoInversion').show();		
				$('#lblPorci').show();
			}
		
		
				function muestraInverionVariable(){
				$('#lblTasaBase').show();
				$('#tasaBase').show();
				$('#descripcionTasaBaseID').show();
				$('#calculoInteres').show();
				$('#lblCalculoInteres').show();
				$('#lblSobreTasa').show();
				$('#sobreTasa').show();
				$('#lblPisoTasa').show();
				$('#pisoTasa').show();
				$('#lblTechoTasa').show();
				$('#techoTasa').show();
				$('#lblTasaAnualizada').hide();
				$('#conceptoInversion').hide();
				$('#lblPorci').hide();
				
			}
					
				
				function agregaMontosPlazos(){
					var montoDescri=$("#montoID option:selected").html();
					var plazoDescri=$("#plazoID option:selected").html();
					var resultadoMonto = montoDescri.split(" a ");
					var resultadoPlazo =plazoDescri.split(" - ");
					var i =0;
					var j =0;
					for (i=0; i<resultadoMonto.length; i++){
						if(i==0){						
							$('#montoInferior').val(resultadoMonto[i].replace(/\,/g,''));
						}else{
							$('#montoSuperior').val(resultadoMonto[i].replace(/\,/g,''));
						}
					}
				
					for (j=0; j<resultadoPlazo.length; j++){
						if(j==0){
							$('#plazoInferior').val(resultadoPlazo[j]);
						}else{
							$('#plazoSuperior').val(resultadoPlazo[j]);
						}
					}
				}
				
				
				function consultaTasa(){
					var estatusTipoCed = "";
					var tasaID=$('#tasaCedeID').val();
					var bean ={
							'tasaCedeID' :tasaID,
							'tipoCedeID':$('#tipoCedeID').val()
						};
						setTimeout("$('#cajaLista').hide();", 200);
							if(tasaID != '' && !isNaN(tasaID) && esTab){
									tasasCedesServicio.consulta(catTipoConsulta.principal,bean, function(tasas){
										if(tasas!=null){
											$("#montoID").val(tasas.montoID);
											$("#plazoID").val(tasas.plazoID);
											$('#calificacion').val(tasas.calificacion);											
					
											$('#tasaFija').val(tasas.tasaFija);
											$('#tasaBase').val(tasas.tasaBase);
											$('#sobreTasa').val(tasas.sobreTasa);
											$('#pisoTasa').val(tasas.pisoTasa);
											$('#techoTasa').val(tasas.techoTasa);
											if($('#lblTasaAnualizada').is(":visible")==false){
												validaTasaBase('tasaBase');
												$('#calculoInteres').val(tasas.calculoInteres);
											}
											listarSucursales(12);
											deshabilitaBoton('agrega','submit');
											estatusTipoCed = $('#estatusTipoCede').val();
											if(estatusTipoCed == 'I'){
												deshabilitaBoton('modifica','submit');
												deshabilitaBoton('eliminar', 'submit');
												mensajeSis("El Producto "+$('#descripcionTipo').val()+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
												$('#tipoCedeID').focus();
											}else{
												habilitaBoton('modifica','submit');
												habilitaBoton('eliminar', 'submit');
											}
											
										}else{
											listarSucursales(0);
											inicializaForma('formaGenerica','tasaCedeID');
											deshabilitaBoton('modifica','submit');
											deshabilitaBoton('eliminar', 'submit');
											deshabilitaBoton('agrega','submit');
											$('#calculoInteres').val(1);
											$('#descripcionTasaBaseID').val("");
											$('#calificacion').val("N");
											$('#tasaCedeID').focus();
											consultaGridTasas();
											mensajeSis("El Número de Tasa no Existe.");
											$('#montoID').val("cero");
											$('#plazoID').val("cero");
											$('#calificacion').val("");	
											$('#tasaFija').val("");
											
										}
							});
						}
				}				
				
				
				function ValidaMontoPlazo(e){
					if($('#plazoID').val()=="cero"){
						mensajeSis("Especifique Rango de Plazo.");
						$('#plazoID').focus();
						event.preventDefault();
					}else
						if($('#montoID').val()=="cero"){
							mensajeSis("Especifique Rango de Monto.");
							$('#montoID').focus();
							event.preventDefault();
						}else
							if($('#calificacion').val()==""){
								mensajeSis("Especifique Calificacion.");
								$('#calificacion').focus();
								event.preventDefault();
							}else
							if($('#lblTasaAnualizada').is(":visible")==false){
								if ($('#tasaBase').val()=="" || $('#tasaBase').asNumber()==0){
									mensajeSis("Especifique una Tasa Base.");
										$('#tasaBase').focus();
										event.preventDefault();
								}else{
										if ($('#calculoInteres').val()=="1"){
											mensajeSis("Seleccione un Tipo de Calculo de Interes.");
												$('#calculoInteres').focus();
												event.preventDefault();
										}else{
											
										}
								}
							}
							if($('#lblTasaAnualizada').is(":visible")==true){
								if ($('#tasaFija').val()=="" || $('#tasaFija').asNumber()==0){
									mensajeSis("Especifique Tasa Anualizada.");
									$('#tasaFija').focus();
									event.preventDefault();
								}else{
									
										
								}
							}
				}
				function validaSucursales(e){
					var totales=0;
					var totalesEsta=0;
					$('tr[name=renglon]').each(function() {
						var numero= this.id.substr(7,this.id.length);	
						var sucursal=eval("'#sucursalID" + numero+ "'");
						var estatus=eval("'#estatuscheck" + numero+ "'");
						if($(sucursal).asNumber()>0){
							totales++;
						}
						if($(sucursal).asNumber()>0 && $(estatus).is(':checked')==false){
							totalesEsta++;
						}
					});
					
					if(totales==0){
						mensajeSis("Indique por lo Menos una Sucursal de la sección de Filtros.");
						$('#sucursalID').focus();
						event.preventDefault();
					}
					if(totales==totalesEsta && totales>0){
						mensajeSis("Debe de haber por lo Menos una Sucursal disponible para el Número de Tasa.");
						$('#estatuscheck1').focus();
						event.preventDefault();
					}
				}

		});


	
		function validaDigitos(e){
			key=(document.all) ? e.keyCode : e.which;
			if (key < 48 || key > 57 || key == 46){
				if (key==8|| key == 46 || key == 0){
					return true;
				}
				else 
		  		return false;
			}
		}
		
		
		
		function consultaGridTasas(){
				if($('#tipoCedeID').val()!=0){
					var params = {};
					params['tipoLista'] = 2;
					params['tipoCedeID'] =$('#tipoCedeID').val();
					params['tasaFV']=$('#tasaFV').val();
					$.post("gridTasasCedes.htm", params, function(data){
						if(data.length >0) {
							$('#tasasCedesGrid').html(data);
							$('#tasasCedesGrid').show();
							var numFilas = consultaFilas();
							if(numFilas>0){
								$('#tasasCedesGrid').html(data);
								$('#tasasCedesGrid').show();
							}else{
								$('#tasasCedesGrid').html("");
								$('#tasasCedesGrid').hide();
							}
		
						}else{
							$('#tasasCedesGrid').html("");
							$('#tasasCedesGrid').hide();
						}
					});
				}
				
		}
		
		
		function consultaFilas(){
			var totales=0;
			$('tr[name=renglon]').each(function() {
				totales++;
		
			});
			return totales;
		}		
		

		
		function limpiaCamposSuc(){
			$('#sucursalID').val("");

			$('#estadoID').val("");
			$('#sucursalIDDes').val("");
			$('#sucursalIDDes').val("");
			$('#estadoIDDes').val("");
			$('#excSucursal').attr("checked",false);
			$('#excEstado').attr("checked",false);
			$('#calificacion').val("");
			$('#tasaBase').val('0');
			$('#sobreTasa').val('0.0');
			$('#tasaFija').val("");
			
		}
		function cambiaCalculoInteres(){
			if($('#calculoInteres').val()==2 || $('#calculoInteres').val()==3 || $('#calculoInteres').val()==4){
				$('#techoTasa').attr('readonly',true);
				$('#pisoTasa').attr('readonly',true);
				$('#sobreTasa').attr('readonly',false);
				$('#techoTasa').val('0.0');
				$('#pisoTasa').val('0.0');
				$('#sobreTasa').val('0.0');
	
		
			}

			if($('#calculoInteres').val()==5 || $('#calculoInteres').val()==6 || $('#calculoInteres').val()==7){
				$('#techoTasa').attr('readonly',false);
				$('#pisoTasa').attr('readonly',false);
				$('#sobreTasa').attr('readonly',false);
				$('#tasaBaseID').attr('readonly',false);
				$('#tdSobreTasa').attr('readonly',false);
				$('#techoTasa').val('0.0');
				$('#pisoTasa').val('0.0');
				$('#sobreTasa').val('0.0');
	
			}
			
		}
		
		
		
		function validadorConPunto(e){
			key=(document.all) ? e.keyCode : e.which;
			if (key < 48 || key > 57 || key == 46){
				if (key==8|| key == 46 || key == 0){
					return true;
				}
				else 
		  		return false;
			}
		}

		function validador(e){
			key=(document.all) ? e.keyCode : e.which;
			if (key < 48 || key > 57){
				if (key==8 || key == 0 || key == 37){
					return true;
				}
				else 
		  		return false;
			}
		}
		

		function exitoTransaccionGrabar(){

		}

		function falloTransaccionGrabar(){

		}