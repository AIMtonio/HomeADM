		
	$(document).ready(function() {
			esTab = true;
		
			$("#tipoAportacionID").focus();
			deshabilitaBoton('imprimir','submit');
			deshabilitaBoton('grabar','submit');
			
			$(':text').focus(function() {	
			 	esTab = false;
			});
			var tipoTransaccion= {
					'grabar' : '1',	
					'eliminar':'2'
				};
			 
			var tipoLista= {
					'todasCuenta' : '7',	
					'foraneaSucursal' : '4',
					'principalEstados' : 1,
					'principalPlazas'  : 1,
					'principalRegiones'  : 1,
					'principalSucursalesGrid'  : 1,
					'filtroSucursal' : 2,
					'filtroPlaza' : 3,
					'filtroRegion' : 4,
					'filtroEstado' : 5,
					'filtroDirVtas' : 6
				};
			var tipoConsulta= {
					'principalCuenta' : 1,	
					'principalSucursal' : 1,
					'principalEstados'  : 1,
					'principalPlazas'  : 1,
					'principalRegiones' : 1,
					'principal':1
				};
			var tipoFiltro= {
					'sucursal': 1,	
					'plaza'   : 2,
					'region'  : 3,
					'estado'  : 4,
					'todos'	  : 5,
					'dirVentas':6
				};
			
			
			
			
			
			$.validator.setDefaults({		
			    submitHandler: function(event) { 
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoAportacionID',
			    			'exitoTransaccionGrabar','falloTransaccionGrabar'); 		
			      }
			 });
			
			$(':text').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});
			/* ======================== Validaciones de la Forma ======================= */
			$('#formaGenerica').validate({
				rules: {            
					tipoAportacionID	:  {
						required 	: 	true
					}	
				},
				
				messages: {     
					tipoAportacionID		: {
						required	: 'Especifique tipo de Aportación',
					}
				}
			});
			
			
			/* ====================== MANEJO DE EVENTOS ============================= */
			
			
			/*asigna el tipo de transaccion */
			$('#grabar').click(function() {	
				
				$('#instrumentoID').val($('#tipoAportacionID').val());
				if(parseInt(consultaFilas())==0){
					$('#tipoTransaccion').val(tipoTransaccion.eliminar);
				}else{				
					$('#tipoTransaccion').val(tipoTransaccion.grabar);			
				}
				
			});

					
			$('#tipoAportacionID').bind('keyup',function(e){	
				 var camposLista = new Array();
				 var parametrosLista = new Array();
				 camposLista[0] = "descripcion";
				 parametrosLista[0] = $('#tipoAportacionID').val();
				
				lista('tipoAportacionID', 2, 1, camposLista,
						 parametrosLista, 'listaTiposAportaciones.htm');
			});
			

			$('#tipoAportacionID').blur(function() {
				if(esTab){
					validaTipoAportacion($('#tipoAportacionID').val());		
	
				}
			});
			
			
			
			
			/*busca y lista las sucursales */
			$('#sucursalID').bind('keyup',function(e){
				lista('sucursalID', '2', tipoLista.foraneaSucursal, 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
			});
			$('#sucursalID').blur(function() {
				if(esTab == true){
					validaSucursal();
					$('#excSucursal').attr('checked', false); 
				}
				
			});

			/*busca y lista los estados*/
			$('#estadoID').bind('keyup',function(e) {
				lista('estadoID', '2', tipoLista.principalEstados, 'nombre',$('#estadoID').val(),'listaEstados.htm');
			});
			$('#estadoID').blur(function() {
				if(esTab){
					validaEstado();
					$('#excEstado').attr('checked', false); 
				}
				
			});
			
			
			$('#agregaSucursal').click(function() {				
				if($("#sucursalID").val() != '' && !isNaN($("#sucursalID").val()) ){
					if($("#excSucursal").is(":checked")){
						quitarSucursales(tipoFiltro.sucursal);
					}else{
						agregarSucursales(tipoLista.filtroSucursal);
					}				
				}else{
					if($("#sucursalID").val() == ''){
						mensajeSis("Indique la Sucursal.");
						$("#sucursalID").focus();
						$("#sucursalID").select();
					}else{
						mensajeSis("La Sucursal Indicada es Incorrecta.");
						$("#sucursalID").focus();
						$("#sucursalID").select();
					}
				}
			});		
			

			$('#agregaEstado').click(function() {
				if($("#estadoID").val() != '' && !isNaN($("#estadoID").val()) ){
					if($("#excEstado").is(":checked")){
						quitarSucursales(tipoFiltro.estado);
					}else{
						agregarSucursales(tipoLista.filtroEstado);
					}
				}else{
					if($("#estadoID").val() == ''){
						mensajeSis("Indique el Estado.");
						$("#estadoID").focus();
						$("#estadoID").select();
					}else{
						mensajeSis("El Estado Indicado es Incorrecto.");
						$("#estadoID").focus();
						$("#estadoID").select();
					}
				}
			});
	
			
			$('#excSucursal').click(function() {
				if($(this).is(":checked")){
					if($("#sucursalID").val() == ''){
						mensajeSis("Indique la Sucursal.");
						$("#sucursalID").focus();
						$("#sucursalID").select();
						$(this).attr('checked', false); 
					}else{
						if(isNaN($("#sucursalID").val())){
							mensajeSis("La Sucursal Indicada es Incorrecta.");
							$("#sucursalID").focus();
							$("#sucursalID").select();
							$(this).attr('checked', false); 
						}
					}
				}
			});


			$('#excEstado').click(function() {
				if($(this).is(":checked")){
					if($("#estadoID").val() == ''){
						mensajeSis("Indique el Estado.");
						$("#estadoID").focus();
						$("#estadoID").select();
						$(this).attr('checked', false); 
					}else{
						if(isNaN($("#estadoID").val())){
							mensajeSis("El Estado Indicado es Incorrecto.");
							$("#estadoID").focus();
							$("#estadoID").select();
							$(this).attr('checked', false); 
						}
					}
				}
			});		
			
			/* ================= FUNCIONES Y VALIDACIONES ============================= */
			
			/*Funcion para consultar el tipo de Aportación*/
			function validaTipoAportacion(tipAport){
				inicializaForma('formaGenerica','tipoAportacionID');	
				$('#divGridSucursales').html("");
				$('#divGridSucursales').hide();
				deshabilitaBoton('grabar', 'submit');
				var TipoAportacionBean ={
					'tipoAportacionID' :tipAport
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(tipAport != '' && !isNaN(tipAport) && esTab){
						tiposAportacionesServicio.consulta(1,TipoAportacionBean, function(tipoAport){
							if(tipoAport!=null){
								$('#tipoAportacionID').val(tipoAport.tipoAportacionID);
								$('#tipoCuentaIDDes').val(tipoAport.descripcion);	
								listarSucursales(tipoLista.principalSucursalesGrid);
							}else{
								$('#tipoCuentaIDDes').val('');
								$('#tipoAportacionID').val('');
								mensajeSis("El Tipo de Aportación no Existe.");
								$('#tipoAportacionID').focus();
								inicializaForma('formaGenerica','tipoAportacionID');
							}
						});
					
				}				
			}
				
			
			
			function validaSucursal() {
				var numSucursal = $('#sucursalID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numSucursal != '' && !isNaN(numSucursal)){
					
					if(numSucursal == '0'){
						$('#sucursalIDDes').val('TODAS');						
					}else{ 						
						sucursalesServicio.consultaSucursal(tipoConsulta.principalSucursal,numSucursal,function(sucursal) { 
							if(sucursal!=null){		
								$('#sucursalID').val(sucursal.sucursalID);
								$('#sucursalIDDes').val(sucursal.nombreSucurs);
								
							}else{
								mensajeSis("No Existe la Sucursal.");
								$('#sucursalIDDes').val('');
								$('#sucursalID').focus();
								$('#sucursalID').select();			
							}
						});
					}
				}
			}

			
		
			
			function validaEstado() {
				var numEstado = $("#estadoID").val();	
				
				setTimeout("$('#cajaLista').hide();", 200);		
				if(numEstado != '' && !isNaN(numEstado) ){
					
					if(numEstado == '0'){
						$('#estadoIDDes').val('TODOS');
						deshabilitaControl('excEstado');
						$("#agregaEstado").focus();
					}else{
						habilitaControl('excEstado');
						$("#excEstado").focus();
						estadosServicio.consulta(tipoConsulta.principalEstados,numEstado,function(estado) {
							if(estado!=null){	
								$('#estadoID').val(estado.estadoID); 
								$('#estadoIDDes').val(estado.nombre); 
							}else{
								mensajeSis("No Existe el Estado.");
								$('#estadoIDDes').val(''); 
								$('#estadoID').focus();	
								$('#estadoID').select();	
							}    	 						
						});
					}
				}
			}
			
	
			// funcion para consultar las sucursales registradas para el tipo de cuenta */
			function listarSucursales(numeroLista){  
					var tipoCuenta = $("#tipoAportacionID").asNumber();
					$('#instrumentoID').val($('#tipoAportacionID').val());
					if (tipoCuenta != ''  && !isNaN(tipoCuenta)){ 
						var params = {};
						params['tipoLista'] = numeroLista;
						params['instrumentoID'] =$('#instrumentoID').val();
						params['tipoInstrumentoID'] =$('#tipoInstrumentoID').val();
						params['sucursalID'] = $("#sucursalID").val();
						params['estadoID'] = $("#estadoID").val();
						
						$.post("gridTipoCuentaSucursalAVista.htm", params, function(sucursalesGrid){	 
							if(sucursalesGrid.length >0) { 
								$('#divGridSucursales').html(sucursalesGrid);
								$('#divGridSucursales').show();	
								
								if(parseInt(consultaFilas()) > 0){
									habilitaBoton('grabar', 'submit');
									habilitaBoton('imprimir', 'submit');
								}else{
									deshabilitaBoton('grabar', 'submit');
									deshabilitaBoton('imprimir', 'submit');
								}
								
							}else{
								$('#divGridSucursales').html("");
								$('#divGridSucursales').hide();
							} 
						});   
				}
				else{
					$('#divGridSucursales').html("");
					$('#divGridSucursales').hide();
				} 
			}
			
			function quitarSucursales(tipo){
				var filasInt= consultaFilas();
							
				$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
				$("#contenedorForma").block({
					 message: $('#mensaje'),
					 css: {border:		'none',
					 background:	'none'}
				});
					
					
					var contador = 0 ;
					var numero= 0;
					var jqControl = "";
					var jqRenglon = "";
					
					deshabilitaBoton('imprimir', 'submit');
					
					$('tr[name=renglon]').each(function() {	
						jqControl = "";
						jqRenglon = "";
						
						numero= this.id.substr(7,this.id.length);
					
		
						switch (tipo){ 
							case tipoFiltro.sucursal:
									jqControl = eval("'#sucursalID" + numero + "'");
									
									if(parseInt($(jqControl).val()) == parseInt($("#sucursalID").val())){
										jqRenglon = eval("'#renglon" + numero + "'");
										$(jqRenglon).remove();
									}
									if($("#sucursalID").val() == "0"){
										jqEstatusCheck = eval("'#estatuscheck" + numero + "'");
										jqEstatus = eval("'#estatus" + numero + "'");
										
										$(jqEstatusCheck).attr('checked', false); 
										$(jqEstatus).val('I');
					    			}
									
						        break;
						    case tipoFiltro.estado:
							    	jqControl = eval("'#estadoID" + numero + "'");
									
									if(parseInt($(jqControl).val()) == parseInt($("#estadoID").val())){
										jqRenglon = eval("'#renglon" + numero + "'");
										$(jqRenglon).remove();
									}
						        break;
						    default:
						}					
						if(parseInt(filasInt)>0){
							habilitaBoton('grabar', 'submit');
						}else{
							deshabilitaBoton('grabar', 'submit');
						}
					
					});
					
					
		
					/*----------Reordenamiento de Controles--------------*/
					contador = 1;			
					
					$('tr[name=renglon]').each(function() {	
						jqControl = "";
						jqRenglon = "";
						numero= this.id.substr(7,this.id.length);
						var jqRenglon = eval("'#renglon"+numero+"'");
						var jqSucursalID = eval("'#sucursalID"+numero+"'");
						var jqNombreSucursal = eval("'#nombreSucursal"+numero+"'");		
						var jqEstadoID=eval("'#estadoID"+ numero+"'");
						var jqNombreEstado=eval("'#nombreEstado"+ numero+"'");						
						var jqEstatus=eval("'#estatus"+ numero+"'");
						var jqEstatuscheck=eval("'#estatuscheck"+ numero+"'");
					
						$(jqRenglon).attr('id','renglon'+contador);
						$(jqSucursalID).attr('id','sucursalID'+contador);
						$(jqNombreSucursal).attr('id','nombreSucursal'+contador);
						$(jqEstadoID).attr('id','estadoID'+ contador);
						$(jqNombreEstado).attr('id','nombreEstado'+contador);
						
						$(jqEstatus).attr('id','estatus'+ contador);
						$(jqEstatuscheck).attr('id','estatuscheck'+ contador);
						
						
						contador = parseInt(contador + 1);	
						
					});
					
					$("#contenedorForma").unblock();
				
			}
			
			function retieneFila(){
				$('#sucursalAuxID').val($('#sucursalID1').val());
				$('#estadoAuxID').val($('#estadoID1').val());
				$('#estatusAux').val($('#estatus1').val());
			}
	}); // fin document
	
	
	function agregarSucursales(numeroLista){ 
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
		$("#contenedorForma").block({
			 message: $('#mensaje'),
			 css: {border:		'none',
				 background:	'none'}
		 });
		
		deshabilitaBoton('imprimir', 'submit');
		
		var params = {};
		params['tipoLista'] = numeroLista;
		params['tipoCuentaID'] = $("#tipoAportacionID").val();
		params['sucursalID'] = $("#sucursalID").val();
		params['estadoID'] = $("#estadoID").val();
		
		tipoCuentaSucursalServicio.lista(numeroLista,params, function(sucursales) {
		$("#contenedorForma").unblock();

		if (sucursales != null && sucursales.length>0) {	
				var i = 0;
				var consecutivo = parseInt(consultaFilas());
				while(i < sucursales.length){
					
					if(!buscarSucursal(sucursales[i].sucursalID)){
							consecutivo ++;
							
							addTD = '<tr id="renglon'+consecutivo+'" name="renglon">' 
									+	'<td  align="center">' 
									+	'	<input type="text" id="sucursalID'+consecutivo+'" name="lSucursalID" size="10" value="'+ sucursales[i].sucursalID +'" readOnly="true" style="text-align:left;" />'					
									+	'</td>'
									+	'<td  align="center"> '
									+	'	<input type="text" id="nombreSucursal'+consecutivo+'" size="30" value="'+ sucursales[i].nombreSucursal +'" readOnly="true" style="text-align:left;" />'					
									+	'</td>' 
									+	'<td  align="center">' 
									+	'	<input type="text" id="nombreEstado'+consecutivo+'" size="30" value="'+ sucursales[i].nombreEstado +'" readOnly="true" style="text-align:left;" />'
									+	'	<input type="hidden" id="estadoID'+consecutivo+'" name="lEstadoID" value="'+ sucursales[i].estadoID +'" />'					
									+	'</td> '
									+	'<td  align="center">'
									+	'	<input type="checkbox" id="estatuscheck'+consecutivo+'" checked onclick="validaEstatus(this)"/>' 
									+	'  <input type="hidden" id="estatus'+consecutivo+'" name="lEstatus" value="'+ sucursales[i].estatus +'" />	'
									+	'</td> '						 
								 	+'</tr>';
							
							$("#tablaGridSucursales").append(addTD);
					}
					
					
					if(parseInt(consultaFilas()) > 0){
						habilitaBoton('grabar', 'submit');
					}else{
						deshabilitaBoton('grabar', 'submit');
					}
					
					
					var addTD = "";
					
					i ++;
				}
		}else{
			mensajeSis('No Hay Sucursales Disponibles.');
		}
	});
}
	
	
	
	/*    cuenta las filas de la tabla del grid       */
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
	
	/*   Verifica si una sucursal ya se encuentra en el listado del grid    */
	function buscarSucursal(sucursalID){
		var ecnontrado = false;
		var jqSucursal = "";
		var numero = 0;
		
		$('tr[name=renglon]').each(function() {
			jqSucursal = "";
			numero= this.id.substr(7,this.id.length);
			var jqSucursal = eval("'#sucursalID"+numero+"'");	
			
			if(parseInt($(jqSucursal).val()) == parseInt(sucursalID) ) {
				ecnontrado = true; 
			}
		});
		return ecnontrado;
	}
	
	
	function validaEstatus(control){
		var estatus= {
				'activo' : 'A',	
				'inactivo' : 'I',	
			};
		var jqSucursal = "";
		var jqCheckEstatus = "";
		var numero= control.id.substr(12,control.id.length);
		 jqSucursal = eval("'#estatuscheck"+numero+"'");	
		 jqCheckEstatus = eval("'#estatus"+numero+"'");	
		
		if($(jqSucursal).is(":checked")){
			$(jqCheckEstatus).val(estatus.activo); 
		}else{
			$(jqCheckEstatus).val(estatus.inactivo); 
		}
	}
	
	
	function exitoTransaccionGrabar(){
		inicializaForma('formaGenerica','tipoAportacionID');	
		$("#tipoAportacionID").focus();
		$('#divGridSucursales').html("");
		$('#divGridSucursales').hide(); 	
		$('#sucursalAuxID').val("");
		$('#estadoAuxID').val("");
		$('#estatusAux').val("");
	}
	
	function falloTransaccionGrabar(){
		
	}
	
	/* Funcion que genera el reporte Proyeccion de Credito, para mostrar la tabla de amortizaciones generada por el simulador */
	function generaReporte() {
		var tipoCuentaID = $("#tipoAportacionID").val();	
		var nombreCuenta = $("#tipoCuentaIDDes").val();
		var tipoReporte = 1; // PDF 
		var nombreInstitucion = parametroBean.nombreInstitucion;	
		var usuario = parametroBean.nombreUsuario;	
		var fechaSistema = parametroBean.fechaSucursal;	

		var tipoInstrumento=$('#tipoInstrumentoID').val();
		
	      url = 'reporteTipoCuentaSucursal.htm?tipoReporte=' + tipoReporte + '&tipoCuentaID='+ tipoCuentaID + '&nombreCuenta=' + nombreCuenta
	      		+ '&nombreInstitucion=' + nombreInstitucion + '&nombreUsuario=' + usuario + '&fechaSistema=' + fechaSistema + '&tipoInstrumentoID='+ tipoInstrumento;
	      window.open(url, '_blank');

}
