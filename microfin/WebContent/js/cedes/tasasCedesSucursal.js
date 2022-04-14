				$(':text').focus(function() {	
				 	esTab = false;
				});
				var tipoTransaccion= {
						'grabar' : '1',	
						'eliminar':'2'
					};
				
				var tipoLista= {
						
						'filtroSucursal' : 7,
						'filtroEstado' : 10,
						'foraneaSucursal' : '4',
						'principalEstados' : 1,
					};
				var tipoConsulta= {
						'principalCuenta' : 1,	
						'principalSucursal' : 1,
						'principalEstados'  : 1,
						'principal':1
					};
				var tipoFiltro= {
						'sucursal': 1,	
						'estado'  : 4,
						'todos'	  : 5,
					};
 
				$(':text').bind('keydown',function(e){
					if (e.which == 9 && !e.shiftKey){
						esTab= true;
					}
				});
				/* ====================== MANEJO DE EVENTOS ============================= */			
			
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

				$('#tipoCedeID').focus();
				
				/*busca y lista los estados*/
				$('#estadoID').bind('keyup',function(e) {
					lista('estadoID', '2', tipoLista.principalEstados, 'nombre',$('#estadoID').val(),'listaEstados.htm');
				});
				$('#estadoID').blur(function() {
					if(esTab == true){
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
							alert("Indique la Sucursal.");
							$("#sucursalID").focus();
							$("#sucursalID").select();
							$(this).attr('checked', false); 
						}else{
							if(isNaN($("#sucursalID").val())){
								alert("La Sucursal Indicada es Incorrecta.");
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
							alert("Indique el Estado.");
							$("#estadoID").focus();
							$("#estadoID").select();
							$(this).attr('checked', false); 
						}else{
							if(isNaN($("#estadoID").val())){
								alert("El Estado Indicado es Incorrecto.");
								$("#estadoID").focus();
								$("#estadoID").select();
								$(this).attr('checked', false); 
							}
						}
					}
				});
				

				
				/* ================= FUNCIONES Y VALIDACIONES ============================= */			
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
									alert("No Existe la Sucursal.");
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
									alert("No Existe el Estado.");
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
						var tipoCuenta = $("#tipoCedeID").asNumber();
						if (tipoCuenta != ''  && !isNaN(tipoCuenta)){ 
							var params = {};
							params['tipoLista'] = numeroLista;
							params['instrumentoID'] =$('#tipoCedeID').val();
							params['tipoInstrumentoID'] =$('#tasaCedeID').val();
							params['sucursalID'] = $("#sucursalID").val();
							params['estadoID'] = $("#estadoID").val();
							
							$.post("gridTipoCuentaSucursalVista.htm", params, function(sucursalesGrid){	 
								if(sucursalesGrid.length >0) { 
									$('#divGridSucursales').html(sucursalesGrid);
									$('#divGridSucursales').show();									
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
						
					//	deshabilitaBoton('imprimir', 'submit');
						
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
		//}); // fin document
		
		
		function agregarSucursales(numeroLista){ 
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
			$("#contenedorForma").block({
				 message: $('#mensaje'),
				 css: {border:		'none',
					 background:	'none'}
			 });
						
			var params = {};
			params['tipoLista'] = numeroLista;
			params['instrumentoID'] = $("#tipoCedeID").val();
			params['sucursalID'] = $("#sucursalID").val();
			params['estadoID'] = $("#estadoID").val();
			params['tipoInstrumentoID'] ='28';
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
						
						var addTD = "";
						i ++;
					}
			}else{
				alert('No Hay Sucursales Disponibles.');
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
			inicializaForma('formaGenerica','tasaCedeID');
			deshabilitaBoton('modifica','submit');
			deshabilitaBoton('agrega','submit');
			$('#calculoInteres').val(1);
			$('#descripcionTasaBaseID').val("");
			$('#calificacion').val("N");
			listarSucursales(1);			
			consultaGridTasas();
			$('#montoID').val("cero");
			$('#plazoID').val("cero");
		}
		
		function falloTransaccionGrabar(){
			
		}
		
