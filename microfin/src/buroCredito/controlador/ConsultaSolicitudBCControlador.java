package buroCredito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.DireccionesClienteBean;
import cliente.bean.EstadosRepubBean;
import cliente.bean.MunicipiosRepubBean;
import cliente.servicio.ClienteServicio;
import cliente.servicio.DireccionesClienteServicio;
import cliente.servicio.EstadosRepubServicio;
import cliente.servicio.MunicipiosRepubServicio;
import cliente.servicio.MunicipiosRepubServicio.Enum_Con_Municipios;

import credito.bean.AvalesBean;
import credito.bean.ObligadosSolidariosBean;
import credito.bean.ProspectosBean;
import credito.servicio.AvalesServicio;
import credito.servicio.ObligadosSolidariosServicio;
import credito.servicio.ProspectosServicio;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

public class ConsultaSolicitudBCControlador extends SimpleFormController{
	SolBuroCreditoServicio solBuroCreditoServicio = null;
	AvalesServicio avalesServicio = null;
	ObligadosSolidariosServicio obligadosSolidariosServicio = null;
	DireccionesClienteServicio direccionesClienteServicio = null;
	ClienteServicio clienteServicio = null;
	ProspectosServicio prospectosServicio = null;
	EstadosRepubServicio estadosServicio = null ;
	MunicipiosRepubServicio municipiosServicio=null;
	
	int tipoConsultaDirecciones	 = 6;
	int tipoConsultaCliente		 = 1;
	int tipoConsultaAval		 = 1;
	int tipoConsultaOblSolidario = 1;
	
	int tipoTransaccionCCyBC	= 5;
	int tipoTransaccionBC	 	= 6;
	int tipoTransaccionCC	 	= 7;
	
	public ConsultaSolicitudBCControlador(){
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solicitudCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
		AvalesBean avalesBean = new  AvalesBean();
		AvalesBean avales = new  AvalesBean();
		ObligadosSolidariosBean oblSolidBean = new ObligadosSolidariosBean();
		ObligadosSolidariosBean obligados = new ObligadosSolidariosBean();
		DireccionesClienteBean direccionBean = new DireccionesClienteBean();
		DireccionesClienteBean direccion = new DireccionesClienteBean();
		ClienteBean datosCliente = new ClienteBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		EstadosRepubBean estado= new EstadosRepubBean();
		MunicipiosRepubBean municipio= new MunicipiosRepubBean();
		
		String RFC = "";
		String cadenaResupuesta = new String("Error en la Consulta");
		int numero = new Integer(0);

		solBuroCreditoServicio.getSolBuroCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		//Seteamos los valores de solBuroCreditoBean
		String lista = request.getParameter("listaRegistros");
		String[] registros = lista.split("%%");
		
		solBuroCreditoBean.setSolicitudCreditoID(request.getParameter("solicitudCreditoID"));
		solBuroCreditoBean.setOrigenDatos(request.getParameter("origenDatos"));
		solBuroCreditoBean.setUsuarioCirculo(request.getParameter("usuarioCirculo"));
		solBuroCreditoBean.setContrasenaCirculo(request.getParameter("contrasenaCirculo"));
		solBuroCreditoBean.setUsuarioBuroCredito(request.getParameter("usuarioBuroCredito"));
		solBuroCreditoBean.setContraseniaBuroCredito(request.getParameter("contraseniaBuroCredito"));
		solBuroCreditoBean.setUsuario(request.getParameter("usuario"));
		
		for (int i=0; i< registros.length; i++){
			String[] relacion = registros[i].split(",");		
			if (relacion[0].equals("1")){	
				//Para Titular
				if(relacion[2].equals("0")){
					direccionBean.setClienteID(relacion[1]);
					direccion = direccionesClienteServicio.consulta(tipoConsultaDirecciones, direccionBean);
					datosCliente = clienteServicio.consulta(tipoConsultaCliente, relacion[1], RFC);
					estado = estadosServicio.consulta(tipoTransaccion,direccion.getEstadoID());
					municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccion.getEstadoID(), direccion.getMunicipioID());
					solBuroCreditoBean.setClienteID(relacion[1]);
					solBuroCreditoBean.setRFC(datosCliente.getRFC());
					solBuroCreditoBean.setFechaConsulta(datosCliente.getFechaActual());
					solBuroCreditoBean.setPrimerNombre(datosCliente.getPrimerNombre());
					solBuroCreditoBean.setSegundoNombre(datosCliente.getSegundoNombre());
					solBuroCreditoBean.setTercerNombre(datosCliente.getTercerNombre());
					solBuroCreditoBean.setApellidoPaterno(datosCliente.getApellidoPaterno());
					solBuroCreditoBean.setApellidoMaterno(datosCliente.getApellidoMaterno());
					solBuroCreditoBean.setEstadoCivil(datosCliente.getEstadoCivil()); // CC
					solBuroCreditoBean.setSexo(datosCliente.getSexo()); // CC
					solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
					solBuroCreditoBean.setNombreMuni(municipio.getNombre());
					solBuroCreditoBean.setCalle(direccion.getCalle());
					solBuroCreditoBean.setNumeroExterior(direccion.getNumeroCasa());
					solBuroCreditoBean.setNumeroInterior(direccion.getNumInterior());
					solBuroCreditoBean.setPiso(direccion.getPiso());
					solBuroCreditoBean.setNombreColonia(direccion.getColonia());
					solBuroCreditoBean.setCP(direccion.getCP());
					solBuroCreditoBean.setLote(direccion.getLote());
					solBuroCreditoBean.setManzana(direccion.getManzana());
					solBuroCreditoBean.setNombreMuni(direccion.getMunicipioNombre());
					solBuroCreditoBean.setFechaNacimiento(datosCliente.getFechaNacimiento());
					
				}else{
					ProspectosBean direccionPros=null;
					ProspectosBean prospectoBean= new ProspectosBean();
					prospectoBean.setProspectoID(relacion[2]);
					
					direccionPros = prospectosServicio.consulta(tipoConsultaCliente, prospectoBean);
					estado = estadosServicio.consulta(tipoTransaccion,direccionPros.getEstadoID());
					municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccionPros.getEstadoID(), direccionPros.getMunicipioID());
					
					solBuroCreditoBean.setClienteID(relacion[2]);
					
					solBuroCreditoBean.setRFC(direccionPros.getRFC());
					solBuroCreditoBean.setFechaConsulta(direccionPros.getFechaActual());
					solBuroCreditoBean.setPrimerNombre(direccionPros.getPrimerNombre());
					solBuroCreditoBean.setSegundoNombre(direccionPros.getSegundoNombre());
					solBuroCreditoBean.setTercerNombre(direccionPros.getTercerNombre());
					solBuroCreditoBean.setApellidoPaterno(direccionPros.getApellidoPaterno());
					solBuroCreditoBean.setApellidoMaterno(direccionPros.getApellidoMaterno());					
					solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
					solBuroCreditoBean.setNombreMuni(municipio.getNombre());
					solBuroCreditoBean.setCalle(direccionPros.getCalle());
					solBuroCreditoBean.setNumeroExterior(direccionPros.getNumExterior());
					solBuroCreditoBean.setNumeroInterior(direccionPros.getNumInterior());
					solBuroCreditoBean.setNombreColonia(direccionPros.getColonia());
					solBuroCreditoBean.setCP(direccionPros.getCP());
					solBuroCreditoBean.setLote(direccionPros.getLote());
					solBuroCreditoBean.setManzana(direccionPros.getManzana());
					solBuroCreditoBean.setFechaNacimiento(direccionPros.getFechaNacimiento());
					solBuroCreditoBean.setEstadoCivil(direccionPros.getEstadoCivil()); // CC
					solBuroCreditoBean.setSexo(direccionPros.getSexo()); // CC
					

				}
				//Compara el tipo de transaccion que se va a realizar 
				solBuroCreditoBean.setClaveUM("MX");
				if(tipoTransaccion == 5){
					solBuroCreditoBean.setTipoAlta("A");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCCyBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 6){
					solBuroCreditoBean.setTipoAlta("B");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 7){
					solBuroCreditoBean.setTipoAlta("C");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCC,solBuroCreditoBean,request);
				}				
				//mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccion,solBuroCreditoBean, request);
				
			}else if (relacion[0].equals("2")){
				//Para Avales
				if(relacion[2].equals("0") && relacion[3].equals("0")){
					direccionBean.setClienteID(relacion[1]);
					solBuroCreditoBean.setClienteID(relacion[1]);
					direccion = direccionesClienteServicio.consulta(tipoConsultaDirecciones, direccionBean);
					datosCliente = clienteServicio.consulta(tipoConsultaAval, relacion[1], RFC);
					estado = estadosServicio.consulta(tipoTransaccion,direccion.getEstadoID());
					municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccion.getEstadoID(), direccion.getMunicipioID());
						
					solBuroCreditoBean.setRFC(datosCliente.getRFC());
					solBuroCreditoBean.setFechaConsulta(datosCliente.getFechaActual());
					solBuroCreditoBean.setPrimerNombre(datosCliente.getPrimerNombre());
					solBuroCreditoBean.setSegundoNombre(datosCliente.getSegundoNombre());
					solBuroCreditoBean.setTercerNombre(datosCliente.getTercerNombre());
					solBuroCreditoBean.setApellidoPaterno(datosCliente.getApellidoPaterno());
					solBuroCreditoBean.setApellidoMaterno(datosCliente.getApellidoMaterno());
					solBuroCreditoBean.setEstadoCivil(datosCliente.getEstadoCivil()); // CC
					solBuroCreditoBean.setSexo(datosCliente.getSexo()); // CC
					solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
					solBuroCreditoBean.setNombreMuni(municipio.getNombre());
					solBuroCreditoBean.setCalle(direccion.getCalle());
					solBuroCreditoBean.setNumeroExterior(direccion.getNumeroCasa());
					solBuroCreditoBean.setNumeroInterior(direccion.getNumInterior());
					solBuroCreditoBean.setPiso(direccion.getPiso());
					solBuroCreditoBean.setNombreColonia(direccion.getNombreColonia());
					solBuroCreditoBean.setCP(direccion.getCP());
					solBuroCreditoBean.setLote(direccion.getLote());
					solBuroCreditoBean.setManzana(direccion.getManzana());
					solBuroCreditoBean.setFechaNacimiento(datosCliente.getFechaNacimiento());
					
				}else if(relacion[1].equals("0")&& relacion[3].equals("0")){
						ProspectosBean direccionPros=null;
						ProspectosBean prospectoBean= new ProspectosBean();
						prospectoBean.setProspectoID(relacion[2]);
						solBuroCreditoBean.setClienteID(relacion[2]);
										
						direccionPros = prospectosServicio.consulta(tipoConsultaAval, prospectoBean);
						estado = estadosServicio.consulta(tipoTransaccion,direccionPros.getEstadoID());
						municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccion.getEstadoID(), direccion.getMunicipioID());
						
						solBuroCreditoBean.setRFC(direccionPros.getRFC());						
						solBuroCreditoBean.setFechaConsulta(direccionPros.getFechaActual());
						solBuroCreditoBean.setPrimerNombre(direccionPros.getPrimerNombre());
						solBuroCreditoBean.setSegundoNombre(direccionPros.getSegundoNombre());
						solBuroCreditoBean.setTercerNombre(direccionPros.getTercerNombre());
						solBuroCreditoBean.setApellidoPaterno(direccionPros.getApellidoPaterno());
						solBuroCreditoBean.setApellidoMaterno(direccionPros.getApellidoMaterno());
						solBuroCreditoBean.setEstadoCivil(direccionPros.getEstadoCivil()); // CC
						solBuroCreditoBean.setSexo(direccionPros.getSexo()); // CC
					
						solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
						solBuroCreditoBean.setNombreMuni(municipio.getNombre());
						solBuroCreditoBean.setCalle(direccionPros.getCalle());
						solBuroCreditoBean.setNumeroExterior(direccionPros.getNumExterior());
						solBuroCreditoBean.setNumeroInterior(direccionPros.getNumInterior());
						solBuroCreditoBean.setNombreColonia(direccionPros.getColonia());
						solBuroCreditoBean.setCP(direccionPros.getCP());
						solBuroCreditoBean.setLote(direccionPros.getLote());
						solBuroCreditoBean.setManzana(direccionPros.getManzana());
						solBuroCreditoBean.setFechaNacimiento(direccionPros.getFechaNacimiento());
						
					
						}else{
							avalesBean.setAvalID(relacion[3]);
							solBuroCreditoBean.setClienteID(relacion[3]);
							avales = avalesServicio.consulta(tipoConsultaAval, avalesBean);
							estado = estadosServicio.consulta(tipoTransaccion,avales.getEstadoID());
							municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, avales.getEstadoID(), avales.getMunicipioID());
								
							solBuroCreditoBean.setRFC(avales.getrFC());
							solBuroCreditoBean.setFechaConsulta(avales.getFechaActual());
							solBuroCreditoBean.setPrimerNombre(avales.getPrimerNombre());
							solBuroCreditoBean.setSegundoNombre(avales.getSegundoNombre());
							solBuroCreditoBean.setTercerNombre(avales.getTercerNombre());
							solBuroCreditoBean.setApellidoPaterno(avales.getApellidoPaterno());
							solBuroCreditoBean.setApellidoMaterno(avales.getApellidoMaterno());
							solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
							solBuroCreditoBean.setNombreMuni(municipio.getNombre());
							solBuroCreditoBean.setCalle(avales.getCalle());
							solBuroCreditoBean.setNumeroExterior(avales.getNumExterior());
							solBuroCreditoBean.setNumeroInterior(avales.getNumInterior());
							solBuroCreditoBean.setPiso(Constantes.STRING_VACIO);
							solBuroCreditoBean.setNombreColonia(avales.getColonia());
							solBuroCreditoBean.setCP(avales.getcP());
							solBuroCreditoBean.setLote(avales.getLote());
							solBuroCreditoBean.setManzana(avales.getManzana());
							solBuroCreditoBean.setFechaNacimiento(avales.getFechaNac());	
							solBuroCreditoBean.setEstadoCivil(avales.getEstadoCivil()); // CC
							solBuroCreditoBean.setSexo(avales.getSexo()); // CC												
													
						}
				//Compara el tipo de transaccion que se va a realizar 
				solBuroCreditoBean.setClaveUM("MX");
				if(tipoTransaccion == 5){
					solBuroCreditoBean.setTipoAlta("A");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCCyBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 6){
					solBuroCreditoBean.setTipoAlta("B");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 7){
					solBuroCreditoBean.setTipoAlta("C");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCC,solBuroCreditoBean,request);
				}	
				//mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccion,solBuroCreditoBean, request);
			}// fin if Avales	
			else if (relacion[0].equals("3")){
				//Para Obligados Solidarios
				if(relacion[2].equals("0") && relacion[3].equals("0")){
					direccionBean.setClienteID(relacion[1]);
					solBuroCreditoBean.setClienteID(relacion[1]);
					direccion = direccionesClienteServicio.consulta(tipoConsultaDirecciones, direccionBean);
					datosCliente = clienteServicio.consulta(tipoConsultaOblSolidario, relacion[1], RFC);
					estado = estadosServicio.consulta(tipoTransaccion,direccion.getEstadoID());
					municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccion.getEstadoID(), direccion.getMunicipioID());
						
					solBuroCreditoBean.setRFC(datosCliente.getRFC());
					solBuroCreditoBean.setFechaConsulta(datosCliente.getFechaActual());
					solBuroCreditoBean.setPrimerNombre(datosCliente.getPrimerNombre());
					solBuroCreditoBean.setSegundoNombre(datosCliente.getSegundoNombre());
					solBuroCreditoBean.setTercerNombre(datosCliente.getTercerNombre());
					solBuroCreditoBean.setApellidoPaterno(datosCliente.getApellidoPaterno());
					solBuroCreditoBean.setApellidoMaterno(datosCliente.getApellidoMaterno());
					solBuroCreditoBean.setEstadoCivil(datosCliente.getEstadoCivil()); // CC
					solBuroCreditoBean.setSexo(datosCliente.getSexo()); // CC
					solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
					solBuroCreditoBean.setNombreMuni(municipio.getNombre());
					solBuroCreditoBean.setCalle(direccion.getCalle());
					solBuroCreditoBean.setNumeroExterior(direccion.getNumeroCasa());
					solBuroCreditoBean.setNumeroInterior(direccion.getNumInterior());
					solBuroCreditoBean.setPiso(direccion.getPiso());
					solBuroCreditoBean.setNombreColonia(direccion.getNombreColonia());
					solBuroCreditoBean.setCP(direccion.getCP());
					solBuroCreditoBean.setLote(direccion.getLote());
					solBuroCreditoBean.setManzana(direccion.getManzana());
					solBuroCreditoBean.setFechaNacimiento(datosCliente.getFechaNacimiento());
					
				}else if(relacion[1].equals("0")&& relacion[3].equals("0")){
						ProspectosBean direccionPros=null;
						ProspectosBean prospectoBean= new ProspectosBean();
						prospectoBean.setProspectoID(relacion[2]);
						solBuroCreditoBean.setClienteID(relacion[2]);
										
						direccionPros = prospectosServicio.consulta(tipoConsultaOblSolidario, prospectoBean);
						estado = estadosServicio.consulta(tipoTransaccion,direccionPros.getEstadoID());
						municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, direccion.getEstadoID(), direccion.getMunicipioID());
						
						solBuroCreditoBean.setRFC(direccionPros.getRFC());						
						solBuroCreditoBean.setFechaConsulta(direccionPros.getFechaActual());
						solBuroCreditoBean.setPrimerNombre(direccionPros.getPrimerNombre());
						solBuroCreditoBean.setSegundoNombre(direccionPros.getSegundoNombre());
						solBuroCreditoBean.setTercerNombre(direccionPros.getTercerNombre());
						solBuroCreditoBean.setApellidoPaterno(direccionPros.getApellidoPaterno());
						solBuroCreditoBean.setApellidoMaterno(direccionPros.getApellidoMaterno());
						solBuroCreditoBean.setEstadoCivil(direccionPros.getEstadoCivil()); // CC
						solBuroCreditoBean.setSexo(direccionPros.getSexo()); // CC
					
						solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
						solBuroCreditoBean.setNombreMuni(municipio.getNombre());
						solBuroCreditoBean.setCalle(direccionPros.getCalle());
						solBuroCreditoBean.setNumeroExterior(direccionPros.getNumExterior());
						solBuroCreditoBean.setNumeroInterior(direccionPros.getNumInterior());
						solBuroCreditoBean.setNombreColonia(direccionPros.getColonia());
						solBuroCreditoBean.setCP(direccionPros.getCP());
						solBuroCreditoBean.setLote(direccionPros.getLote());
						solBuroCreditoBean.setManzana(direccionPros.getManzana());
						solBuroCreditoBean.setFechaNacimiento(direccionPros.getFechaNacimiento());
						
					
						}else{
							oblSolidBean.setOblSolidarioID(relacion[3]);
							solBuroCreditoBean.setClienteID(relacion[3]);
							obligados = obligadosSolidariosServicio.consulta(tipoConsultaOblSolidario, oblSolidBean);
							estado = estadosServicio.consulta(tipoTransaccion,obligados.getEstadoID());
							municipio= municipiosServicio.consulta(Enum_Con_Municipios.foranea, obligados.getEstadoID(), obligados.getMunicipioID());
								
							solBuroCreditoBean.setRFC(obligados.getrFC());
							solBuroCreditoBean.setFechaConsulta(obligados.getFechaActual());
							solBuroCreditoBean.setPrimerNombre(obligados.getPrimerNombre());
							solBuroCreditoBean.setSegundoNombre(obligados.getSegundoNombre());
							solBuroCreditoBean.setTercerNombre(obligados.getTercerNombre());
							solBuroCreditoBean.setApellidoPaterno(obligados.getApellidoPaterno());
							solBuroCreditoBean.setApellidoMaterno(obligados.getApellidoMaterno());
							solBuroCreditoBean.setClaveEstado(estado.getEqBuroCredito());
							solBuroCreditoBean.setNombreMuni(municipio.getNombre());
							solBuroCreditoBean.setCalle(obligados.getCalle());
							solBuroCreditoBean.setNumeroExterior(obligados.getNumExterior());
							solBuroCreditoBean.setNumeroInterior(obligados.getNumInterior());
							solBuroCreditoBean.setPiso(Constantes.STRING_VACIO);
							solBuroCreditoBean.setNombreColonia(obligados.getColonia());
							solBuroCreditoBean.setCP(obligados.getcP());
							solBuroCreditoBean.setLote(obligados.getLote());
							solBuroCreditoBean.setManzana(obligados.getManzana());
							solBuroCreditoBean.setFechaNacimiento(obligados.getFechaNac());	
							solBuroCreditoBean.setEstadoCivil(obligados.getEstadoCivil()); // CC
							solBuroCreditoBean.setSexo(obligados.getSexo()); // CC												
													
						}
				//Compara el tipo de transaccion que se va a realizar 
				solBuroCreditoBean.setClaveUM("MX");
				if(tipoTransaccion == 5){
					solBuroCreditoBean.setTipoAlta("A");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCCyBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 6){
					solBuroCreditoBean.setTipoAlta("B");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionBC,solBuroCreditoBean,request);
				}if(tipoTransaccion == 7){
					solBuroCreditoBean.setTipoAlta("C");
					mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccionCC,solBuroCreditoBean,request);
				}
			}
		}// fin for
			
	if(mensaje.getNumero() == 0){
		mensaje.setDescripcion("Consulta Realizada. <br>Ver Detalles en Datos de Consulta");
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion(cadenaResupuesta+" <br>"+mensaje.getDescripcion());
	}
	

	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolBuroCreditoServicio getSolBuroCreditoServicio() {
		return solBuroCreditoServicio;
	}

	public void setSolBuroCreditoServicio(
			SolBuroCreditoServicio solBuroCreditoServicio) {
		this.solBuroCreditoServicio = solBuroCreditoServicio;
	}

	public AvalesServicio getAvalesServicio() {
		return avalesServicio;
	}

	public void setAvalesServicio(AvalesServicio avalesServicio) {
		this.avalesServicio = avalesServicio;
	}

	public DireccionesClienteServicio getDireccionesClienteServicio() {
		return direccionesClienteServicio;
	}

	public void setDireccionesClienteServicio(
			DireccionesClienteServicio direccionesClienteServicio) {
		this.direccionesClienteServicio = direccionesClienteServicio;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	public ProspectosServicio getProspectosServicio() {
		return prospectosServicio;
	}

	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}

	public EstadosRepubServicio getEstadosServicio() {
		return estadosServicio;
	}

	public void setEstadosServicio(EstadosRepubServicio estadosServicio) {
		this.estadosServicio = estadosServicio;
	}

	public MunicipiosRepubServicio getMunicipiosServicio() {
		return municipiosServicio;
	}

	public void setMunicipiosServicio(MunicipiosRepubServicio municipiosServicio) {
		this.municipiosServicio = municipiosServicio;
	}

	public ObligadosSolidariosServicio getObligadosSolidariosServicio() {
		return obligadosSolidariosServicio;
	}

	public void setObligadosSolidariosServicio(
			ObligadosSolidariosServicio obligadosSolidariosServicio) {
		this.obligadosSolidariosServicio = obligadosSolidariosServicio;
	}
	
	
}
