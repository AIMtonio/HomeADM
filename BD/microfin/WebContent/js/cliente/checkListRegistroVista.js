$(document).ready(function() {
	
	$("#clienteID").focus();
	
		esTab = true;
	 	var tab2=false;
	
	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('grabar', 'submit');
   deshabilitaBoton('expediente', 'submit');
	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});

	
	$.validator.setDefaults({
      submitHandler: function(event) {   
      grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','InicializarExitoPantalla','ErrorAutorizacion');
     
      }
   });		
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(1);	
		guardarGriDocumentos();
	});

	$('#expediente').click(function() {	
		consultaNumeroDocumentosPorCliente();
	});
	
	
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	
	$('#clienteID').blur(function() {		
		if(isNaN($('#clienteID').val()) ){
			$('#clienteID').val("");
			$('#clienteID').focus();
			inicializaForma('formaGenerica','clienteID');
		//	tab2 = false;
		 }else{ 
				consultaCliente(this.id); 
		}
	});
	

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required'			
		},
		
		messages: {
			clienteID: 'Especifique numero de cliente'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	
	//Funcion para consultar el numero de documentos por cliente. y generar reporte
	function consultaNumeroDocumentosPorCliente() { 
		var  clienteArchivosBean={
			'prospectoID' :0,
			'clienteID' : $('#clienteID').val() 
		};			
//		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true; 
		if( $('#clienteID').val() != '' || !isNaN( $('#clienteID').val()) && esTab){
			clienteArchivosServicio.consulta(3,clienteArchivosBean,function(clienteArchivos) { 
				if(clienteArchivos!=null){
					numeroDocumentos = 	clienteArchivos.numeroDocumentos;				
					if(numeroDocumentos > 0 ){						var parametrosBean = consultaParametrosSession();
						var fechaEmision = parametrosBean.fechaAplicacion;
						var nombreUsuario = parametrosBean.claveUsuario;
						var nombreInstitucion = parametrosBean.nombreInstitucion;
						var clienteID = $('#clienteID').val();
						var nombre=$('#nombreCliente').val();
						var prospectoID = "0";
						var nombreProspecto="";
						var pagina='clientesFilePDF.htm?clienteID='+clienteID+'&nombreCliente='+nombre+
							'&prospectoID='+prospectoID+'&nombreProspecto='+nombreProspecto+
							'&nombreUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+'&nombreInstitucion='	+nombreInstitucion;

					window.open(pagina);

					} else{
						mensajeSis("El cliente no tiene documentos digitalizados.");
					}
				}else{
					mensajeSis("El cliente no tiene documentos digitalizados.");
				}
			});																										
		}
	}

		
});


//se construye la cadena de datos del grid a guargar
function guardarGriDocumentos(){		
	var mandar = verificarVacios();
	$('#datosGridDocEnt').val("");
	if(mandar!=1){   		  		
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var grupo= eval("'#grupoDocumentoID" + numero + "'");   
			var tipoDoc= eval("'#tipoDocumentoID" + numero + "'");   
			var comentario= eval("'#comentarios" + numero + "'");   
			var aceptado= eval("'#docAceptado" + numero + "'");   
			
			if ($(aceptado).val()=="S"){
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() + '['+
					$(grupo).val() + ']' + $(tipoDoc).val() + ']' +
					$(comentario).val() +']'+
					$(aceptado).val());
			}else{
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() + '['+
					$(grupo).val() + ']' + "9999" + ']' +
					"" +']'+"N");	
			}			
		});
	}else{
		mensajeSis("Faltan Datos");
		event.preventDefault();
	}
}	

//verificamos que no existan campos vacios en el grid de documentos
function verificarVacios(){	
	quitaFormatoControles('documentosEnt');
	var numDoc = consultaFilas();		 
	$('#datosGridDocEnt').val("");
	
	for(var i = 1; i <= numDoc; i++){
		var idDocAcep = document.getElementById("docAceptado"+i+"").value;				
		var idcde = document.getElementById("comentarios"+i+"").value;
		if (idcde =="" && idDocAcep=="S"){ 				
				document.getElementById("comentarios"+i+"").focus();
 				$(idcde).addClass("error");
 					return 1; 
		}
		
		var idcTipoDoc = document.getElementById("tipoDocumentoID"+i+"").value;
		if (idcTipoDoc =="9999" && idDocAcep=="S"){ 				
				document.getElementById("tipoDocumentoID"+i+"").focus();
 				$(idcde).addClass("error");
 					return 1; 
		}
			
	}
}

//Definicion de Constantes y Enums  
var catTipoConsultaCreditoAut = {
		'principal':1,
		'foranea':2,
		'actualizaAut':3 
};	


function consultaCliente(control) {		
	var masculino='M';
	var femenino='F';
	var moral='M';
	var fisicaActividaEmpresarial='A';
	var fisica='F';		
	var numCliente = $('#clienteID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(1,numCliente,function(cliente) {
				if (cliente != null) {						
					$('#telefono').val(cliente.telefonoCasa);				
					if (cliente.fechaNacimiento == '1900-01-01'){
						$('#fechaNacimiento').val('');
					}else{
						$('#fechaNacimiento').val(cliente.fechaNacimiento);
					}
					$('#nombreCliente').val(cliente.nombreCompleto);	
					if(cliente.sexo==masculino ){
						$('#sexo').val('MASCULINO');
					}
					if(cliente.sexo==femenino ){
						$('#sexo').val('FEMENINO');
					}
					if(cliente.tipoPersona==moral ){
						$('#tipoPersona').val('MORAL');
					}
					if(cliente.tipoPersona==fisicaActividaEmpresarial){
						$('#tipoPersona').val('FISICA CON ACT. EMP.');
					}
					if(cliente.tipoPersona==fisica){
						$('#tipoPersona').val('FISICA');
					}
									
					if (cliente.estatus=='I'){
							mensajeSis("El Cliente se encuentra Inactivo");
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#tipoPersona').val('');
							$('#sexo').val('');
							$('#fechaNac').val('');
							$('#telefono').val('');
							$('#clienteID').focus();
							deshabilitaBoton('grabar','submit');
					}else{
						 habilitaBoton('grabar','submit');
					}
					$('#instrumento').val(numCliente);	
					$('#tipoInstrumento').val(4);	
					consultaGridDocEnt();
				
				} else {
					$('#divComentarios').hide();
					limpiaForm($('#formaGenerica'));
					mensajeSis("No Existe el Cliente");
					deshabilitaBoton('grabar','submit');
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			});		
	}
}


 


//grid de documentos entregados
function consultaGridDocEnt(){		
	$('#datosGridDocEnt').val('');
	var params = {};
	params['tipoLista'] = 1;	
	params['instrumento'] = $('#instrumento').val();	
	params['tipoInstrumento'] = $('#tipoInstrumento').val();	
	
	$.post("grupoDoctosGridVista.htm", params, function(data){
		if(data.length >0) {	
			$('#documentosEnt').html(data);
			$('#documentosEnt').show();	
			$('#fieldsetDocEnt').show();
			var numFilas=consultaFilas();		
			if(numFilas == 0 ){
				$('#documentosEnt').html("");
				$('#documentosEnt').hide();	
				$('#fieldsetDocEnt').hide();
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('expediente', 'submit');
			}else{
				habilitaBoton('grabar', 'submit');
				habilitaBoton('expediente', 'submit');			
				
			}
			hasChecked();
			ConsultaTipoDocumentoid();
			$('#expediente').focus();
			$('#tipoDocumentoID1').focus();
		}else{				
			$('#documentosEnt').html("");
			$('#documentosEnt').hide();
			$('#fieldsetDocEnt').hide();			
		}
	});
}


 	
 	function Combo(grupoid,tipo,numero){
 					var tipoLista=2;
 					var grupoBean = {
					'grupoDocumentoID':grupoid
					};			 	
				    clasificaGrpDoctosServicio.listaCombo(grupoBean,tipoLista, function(grupos){
					dwr.util.removeAllOptions(tipo); 
					dwr.util.addOptions(tipo, {'9999':'SELECCIONAR'});
					dwr.util.addOptions(tipo, grupos, 'tipoDocumentoID', 'descripcion');		
					$("#"+tipo).val(numero);
					});
 	}
 	
 	
 	
 	
  function InicializarExitoPantalla() {	
		inicializaForma('formaGenerica','clienteID');  
		$('#documentosEnt').html("");
		$('#documentosEnt').hide();	
		$('#fieldsetDocEnt').hide();
		$('#divComentarios').hide();
		$('#tipoPersona').val("");
		$('#nombreCliente').val("");
		$('#sexo').val("");
		$('#fechaNacimiento').val("");
  }
  
   // Consulta el número de filas del grid de documentos entregados
  function consultaFilas(){
		var totales=0;
		$('tr[name=renglons]').each(function() {
			totales++;
			
		});
		return totales;
	}

  //Si se da clic en el campo docAceptado del grid de Documentos Entregados cambia el valor a S
  function realiza(control){	
	  var  si='S';
	  var no='N';
		if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;		
		}else{
			document.getElementById(control).value = no;
	 }
			
  }
  
  //al cargar el grid de documentos verifica cuales tienen valo 'S' y los selecciona
  function hasChecked(){	
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'documentoAcep" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var documentoAceptado='S';
			if(valorChecked==documentoAceptado){
				$('#docAceptado'+numero).attr('checked','true');					
			}else{
				$('#docAceptado'+numero).attr('checked',false);
			}	
		});
		
	}
  
  
  //Al cargar el grid consulta que tipo de Documento se guardo
  function ConsultaTipoDocumentoid(){	
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdSelect = eval("'tipo" + numero+ "'");	
			var valorTipoDoc = eval("'#tipoDocumentoID" + numero+ "  option:selected'");	
			var valorSelect= document.getElementById(jqIdSelect).value;					
			$(valorTipoDoc).val(valorSelect);
		});
		
	}
