$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoListaTipoInversion = {
			'principal':1
		};
	var catTipoConsultaTipoInversion = {
			'principal':1,
			'general':3
		};
	var principal = 1;
	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#lineaFondeoID').val();
	$('#descripLinea').val('');
	$('#institutFondID').val();
	$('#nombreInstitFondeo').val('');
	$('#creditoFondeoID').val();
	$('#folio').val("");
	deshabilitaBoton('imprimir', 'submit');
	
	$('#pdf').attr("checked",true);
	$('#pantalla').attr("checked",false);
	$('#reporte').val(2);
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha:{
				required : true,
				date : true
			},
			lineaFondeoID:{
				required : true
			
			},
			institutFondID:{
				required : true
				
			},
			creditoFondeoID:{
				required : true
				
				
			}
		},
		
		messages: {
			fecha: {
				required : 'La fecha es requerida',
				date : 'Especifique una fecha correcta'
			},
			lineaFondeoID:{
				required : 'Línea de fondeo requerida'
				
			},
			institutFondID:{
				required : 'Institución requerida'
				
			},
			creditoFondeoID:{
				required : 'El crédito es requerido'
				
				
			}
		}
	});  

   
	function validaLineaFondeo(control) {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numInstitut = $('#institutFondID').val();
		esTab=true;
		if(numLinea == '' || numLinea == '0'){
			alert('Línea de fondeo requerida');
			$('#descripLinea').val("");
			
			
		}else
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			var lineaFondBeanCon = { 
					'lineaFondeoID':$('#lineaFondeoID').val()
			};
			lineaFonServicio.consulta(principal,lineaFondBeanCon,function(lineaFond) {
				if(lineaFond!=null){
					var lineafondeo = lineaFond.institutFondID;
					if(lineafondeo==numInstitut){ 
						
						$('#descripLinea').val(lineaFond.descripLinea);
						$('#institucionID').val(lineaFond.institucionID);
						$('#numCtaInstit').val(lineaFond.numCtaInstit);
						//consultaInstitucionCredito('institucionID');
					}
				else{
					alert("La línea de Fondeo no Corresponde con la Institución");
					$('#lineaFondeoID').val("");
					$('#lineaFondeoID').focus();
					$('#descripLinea').val("");
				}
			}	else{
				
				alert("La línea de Fondeo no Corresponde con la Institución");
				$('#lineaFondeoID').val("");
				$('#lineaFondeoID').focus();
				$('#descripLinea').val("");
			}
		    });
		}
	}

   function validaCreditoFondeo(idControl){
		var numCredito = $('#creditoFondeoID').val();
		var numInstitut = $('#institutFondID').val();
		var numLinea = $('#lineaFondeoID').val();
		
		setTimeout("$('#cajaLista').hide();", 200);
		principal=1;
		esTab=true;
		
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			if(numCredito=='0' || numCredito=='' ){
				alert("No existe el Crédito");
				$('#creditoFondeoID').focus();
				$('#creditoFondeoID').val("");
				
				}else {
				var creditoFondBeanCon = { 
						'creditoFondeoID':numCredito
				};
			creditoFondeoServicio.consulta(principal,creditoFondBeanCon,function(creditoFond) {
				if(creditoFond!=null){
					var lineaFon = creditoFond.lineaFondeoID;
					var institfon = creditoFond.institutFondID;
					if(lineaFon==numLinea && numInstitut == institfon){
						$('#folio').val(creditoFond.folio);
						habilitaBoton('imprimir','submit');
					}else{
						alert("El Crédito no Corresponde con la Institución y la Linea de Fondeo");
						$('#creditoFondeoID').focus();
						$('#creditoFondeoID').val("");
						$('#folio').val("");
					}
				}else{
					alert("No Existe el Crédito de Fondeo");
					$('#creditoFondeoID').focus();
					$('#creditoFondeoID').val("");
					
					
				}
			});
		}
	}
   }
	 
	 function consultaInstitucionFondeo(idControl){
	  var numInstituto = $('#institutFondID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
			var instFondeoBeanCon = {  
	  				'institutFondID':numInstituto
					};
			setTimeout("$('#cajaLista').hide();", 200);	
			if(numInstituto == '' || numInstituto == '0'){
				alert('Institución requerida');
				$('#nombreInstitFondeo').val('');
				
							}else
			if(numInstituto != '' && !isNaN(numInstituto) && esTab){
				fondeoServicio.consulta(principal,instFondeoBeanCon,function(instituto) {
					if(instituto!=null){	
						$('#nombreInstitFondeo').val(instituto.nombreInstitFon);
					}else{
						alert("No Existe la Institución"); 
						$('#institutFondID').focus();
						$('#institutFondID').val("");
						$('#nombreInstitFondeo').val('');
					}    						
				});
			}
		}
		
	 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#pdf').click(function() {
		$('#pdf').focus();
		$('#pdf').attr("checked",true);
		$('#pantalla').attr("checked",false);
		$('#reporte').val(2);
	});
	
	$('#pantalla').click(function() {
		$('#pantalla').focus();
		$('#pantalla').attr("checked",true);
		$('#pdf').attr("checked",false);
		$('#reporte').val(1);
	});
	$('#imprimir').click(function() {		
		var tipoReporte = $('#reporte').val();
		var linea = $('#lineaFondeoID').val();
		var desLinea = $('#descripLinea').val();
		var instit = $('#institutFondID').val();
		var desInst = $('#nombreInstitFondeo').val();
		var credito = $('#creditoFondeoID').val();
		
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var fechaAc = parametroBean.fechaSucursal;
		
		if($('#institutFondID').val()==''|| $('#institutFondID').val()=='0' || $('#nombreInstitFondeo').val()=='' || 
		   $('#lineaFondeoID').val()== ''|| $('#lineaFondeoID').val()== '0' || $('#descripLinea').val()=='' ||
		   $('#creditoFondeoID').val() =='' || $('#creditoFondeoID').val()=='0' || $('#folio').val()=='' ){
		    deshabilitaBoton('imprimir', 'submit');	
			
		    $('#ligaImp').removeAttr('href');		
			
		}else{
			$('#ligaImp').attr('href','lineaFondeoRep.htm?fechaActual='+fechaAc+'&institutFondID='+instit+
					'&nomInstitFon='+desInst+'&lineaFondeoID='+linea+'&descripLinea='+desLinea+'&tipoReporte='+tipoReporte+
					'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&creditoFondeoID='+credito); 	
			
		}	
		
	});
	
	$('#institutFondID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#institutFondID').val())){
	
			 lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		 }
	});
	$('#institutFondID').blur(function() { 
		esTab=true;
		consultaInstitucionFondeo(this.id);
		$('#lineaFondeoID').val('');
		$('#descripLinea').val('');
		$('#creditoFondeoID').val('');
		$('#folio').val("");
		
	});
	
	
	$('#creditoFondeoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreInstitFon";
			camposLista[1] = "lineaFondeoID";
			camposLista[2] = "institutFondID";
	      			
			parametrosLista[0] = $('#creditoFondeoID').val();
			parametrosLista[1] = $('#lineaFondeoID').val();
			parametrosLista[2] = $('#institutFondID').val();
			
			lista('creditoFondeoID', '1', '2', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
		}				       
	});	
	$('#creditoFondeoID').blur(function(){
		validaCreditoFondeo(this.id);
		$('#folio').val("");
	});
	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";


		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		
		lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});
	
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(this.id); 
		$('#creditoFondeoID').val('');
		$('#folio').val("");
	});	
	
});