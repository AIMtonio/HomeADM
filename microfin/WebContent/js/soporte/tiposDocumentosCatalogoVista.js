		$(document).ready(function() {
			$("#tipoDocumentoID").focus();
			esTab = true;
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			
			//Definicion de Constantes y Enums  
			var catTipoTransaccionGrupo = {
					'agrega':'1',
				  	'modifica':'2',
				  	'elimina':'3'
				  		
			};
						
			var catConsultaGrupo = {
					'principal':3
			};	
				
				
			//------------ Metodos y Manejo de Eventos -----------------------------------------
				$(':text').focus(function() {	
				 	esTab = false;
				});	
				
				$.validator.setDefaults({
					submitHandler: function(event) { 
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoDocumentoID','Exito','Error'); 
					}
			    });			
					    
				$(':text').bind('keydown',function(e){
					if (e.which == 9 && !e.shiftKey){
						esTab= true;
					}
				});
				
				$('#agrega').click(function() {		
					$('#tipoTransaccion').val(catTipoTransaccionGrupo.agrega);
				});
						
				$('#modifica').click(function() {		
					$('#tipoTransaccion').val(catTipoTransaccionGrupo.modifica);
				});
			
			
				
				
				$('#tipoDocumentoID').blur(function() {
					$('#descripcion').val('');
					$("#requeridoEn option").removeAttr("selected");
					if(	$('#tipoDocumentoID').asNumber()>0){
						consultaTipoDocumento();
					}else if($('#tipoDocumentoID').val()=="0"){
						habilitaBoton('agrega','submit');
						deshabilitaBoton('modifica','submit');
						deshabilitaControl('estatus');
						$('#descripcion').val('');			  		
					}else{
						deshabilitaBoton('agrega','submit');
						deshabilitaBoton('modifica','submit');
						
					}
				});
				
				$('#tipoDocumentoID').bind('keyup',function(e){
					//TODO Agregar Libreria de Constantes Tipo Enum
					lista('tipoDocumentoID', '2', '3', 'descripcion', $('#tipoDocumentoID').val(), 'ListaTiposDocumentos.htm');
				});
			
					
				//----------- Validaciones de la Forma -------------------------------------
				
				$('#formaGenerica').validate({
					rules: {
						requeridoEn: {
							required: true
						},
						descripcion: {
							required: true
						}
				
					},
					messages: {		
						requeridoEn: {
							required: 'Especifique en que procesos es Requerido'
						},
						descripcion: {
							required: 'Especifique la Descripción'
						}
						
					}		
				});
				
				//------------ Validaciones de Controles ----------
			
				//consulta la descripcion del Tipo de Documento elegido en grid de Tipo de Documentos por Grupo
				function consultaTipoDocumento(){
					setTimeout("$('#cajaLista').hide();", 200);
					var num = $('#tipoDocumentoID').val();			
					var bean={
							'tipoDocumentoID':num
					};
					
					if(num != '' && !isNaN(num)){
							tiposDocumentosServicio.consulta(catConsultaGrupo.principal,bean, function(descripcion) { 
							if(descripcion!=null){
								$('#descripcion').val(descripcion.descripcion);		
								consultaRequeridos(descripcion.requeridoEn);
								$('#estatus').val(descripcion.estatus);
								habilitaBoton('modifica','submit');
								habilitaControl('estatus');
								deshabilitaBoton('agrega','submit');
							}else{
								deshabilitaBoton('modifica','submit');
								deshabilitaBoton('agrega','submit');
								alert("No existe el Tipo de Documento");
								$('#tipoDocumentoID').val("");			
								$('#tipoDocumentoID').focus();			
								$('#descripcion').val("");
								$('#estatus').val("A");
							}
						});
					}
				}
				
				//funcion identifica en que procesos es requerido el documento
				function consultaRequeridos(requerido) {
					var req= requerido.split(',');
					var tamanio = req.length;
					for (var i=0;i< tamanio;i++) {
						var re = req[i];
						var jqRequerido = eval("'#requeridoEn option[value="+re+"]'");  
						$(jqRequerido).attr("selected","selected");	  
					}
				}
								
			});//fin Document
		
		  //Funcion de Exito 
		  function Exito() {
				inicializaForma('formaGenerica','grupoDocumentoID');
				deshabilitaBoton('agrega','submit');
				$("#requeridoEn option").removeAttr("selected");
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');	
				$('#estatus').val("A");
			}
		//Funcion de Error 	
		function Error() {
			}
	
			
					