package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import cliente.BeanWS.Request.ListaClienteRequest;
import cliente.BeanWS.Request.ListaClientesBERequest;
import cliente.BeanWS.Response.ListaClienteResponse;
import cliente.bean.ClienteBean;

public class ClienteDAO extends BaseDAO{

	public ClienteDAO() {
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";
	private final static String NivelBajo = "B";
	// ------------------ Transacciones ------------------------------------------

	/* Alta del Cliente */
	public MensajeTransaccionBean altaCliente(final ClienteBean cliente, final ClienteBean clienteBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CLIENTESALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?," +
										"?,?,?,?,?,	?,?, ?,?,?,"+
										"?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(cliente.getSucursalOrigen()));
									sentenciaStore.setString("Par_TipoPersona",cliente.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",cliente.getTitulo());
									sentenciaStore.setString("Par_PrimerNom",cliente.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom",cliente.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",cliente.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",cliente.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",cliente.getApellidoMaterno());
									sentenciaStore.setDate("Par_FechaNac",herramientas.OperacionesFechas.conversionStrDate(cliente.getFechaNacimiento()));
									sentenciaStore.setInt("Par_LugarNac",Utileria.convierteEntero(cliente.getLugarNacimiento()));

									sentenciaStore.setInt("Par_estadoID",Utileria.convierteEntero(cliente.getEstadoID()));
									sentenciaStore.setString("Par_Nacion",clienteBean.getNacion());
									sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(cliente.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",cliente.getSexo());
									sentenciaStore.setString("Par_CURP",cliente.getCURP());
									sentenciaStore.setString("Par_RFC",cliente.getRFC());
									sentenciaStore.setString("Par_EstadoCivil",cliente.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",cliente.getTelefonoCelular());
									sentenciaStore.setString("Par_Telefono",clienteBean.getTelefonoCasa());
									sentenciaStore.setString("Par_Correo",clienteBean.getCorreo());

									sentenciaStore.setString("Par_RazonSocial",cliente.getRazonSocial());
									sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(cliente.getTipoSociedadID()));
									sentenciaStore.setString("Par_RFCpm",cliente.getRFCpm());
									sentenciaStore.setInt("Par_GrupoEmp",Utileria.convierteEntero(cliente.getGrupoEmpresarial()));
									sentenciaStore.setString("Par_Fax",cliente.getFax());
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(cliente.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",cliente.getPuesto());
									sentenciaStore.setString("Par_LugardeTrab",cliente.getLugarTrabajo());
									sentenciaStore.setDouble("Par_AntTra",Utileria.convierteDoble(cliente.getAntiguedadTra()));
									sentenciaStore.setString("Par_DomicilioTrabajo", cliente.getDomicilioTrabajo());
									sentenciaStore.setString("Par_TelTrabajo",cliente.getTelTrabajo());

									sentenciaStore.setString("Par_Clasific",cliente.getClasificacion());
									sentenciaStore.setString("Par_MotivoApert",cliente.getMotivoApertura());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());
									sentenciaStore.setString("Par_PagaIDE",cliente.getPagaIDE());
									sentenciaStore.setString("Par_NivelRiesgo",NivelBajo);
									sentenciaStore.setInt("Par_SecGeneral",Utileria.convierteEntero(cliente.getSectorGeneral()));
									sentenciaStore.setString("Par_ActBancoMX",cliente.getActividadBancoMX());
									sentenciaStore.setInt("Par_ActINEGI",Utileria.convierteEntero(cliente.getActividadINEGI()));
									sentenciaStore.setInt("Par_SecEconomic",Utileria.convierteEntero(cliente.getSectorEconomico()));

									sentenciaStore.setString("Par_ActFR",cliente.getActividadFR());
									sentenciaStore.setInt("Par_ActFOMUR",Utileria.convierteEntero(cliente.getActividadFOMUR()));
									sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(cliente.getPromotorInicial()));
									sentenciaStore.setInt("Par_PromotorActual",Utileria.convierteEntero(cliente.getPromotorActual()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(cliente.getProspectoID()));
									sentenciaStore.setString("Par_EsMenorEdad",cliente.getEsMenorEdad());
									sentenciaStore.setInt("Par_CorpRelacionado",Utileria.convierteEntero(cliente.getCorpRelacionado()));
									//MANDA EL CONTENIDO DE LA VARIABLE REGISTROHACIENDA AL STORE PAR_REGISTROHACIENDA
									sentenciaStore.setString("Par_RegistroHacienda",cliente.getRegistroHacienda());
									sentenciaStore.setInt("Par_NegocioAfiliadoID",Utileria.convierteEntero(cliente.getNegocioAfiliadoID()));
									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(cliente.getInstitNominaID()));

									sentenciaStore.setString("Par_Observaciones",cliente.getObservaciones());
									sentenciaStore.setString("Par_NoEmpleado",cliente.getNoEmpleado());
									sentenciaStore.setString("Par_TipoEmpleado",cliente.getTipoEmpleado());
									sentenciaStore.setString("Par_ExtTelefonoPart",clienteBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_ExtTelefonoTrab",cliente.getExtTelefonoTrab());

									sentenciaStore.setInt("Par_EjecutivoCap",Utileria.convierteEntero(cliente.getEjecutivoCap()));
									sentenciaStore.setInt("Par_PromotorExtInv",Utileria.convierteEntero(cliente.getPromotorExtInv()));
									sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(cliente.getTipoPuestoID()));
									sentenciaStore.setString("Par_FechaIniTrabajo",Utileria. convierteFecha(cliente.getFechaIniTrabajo()));
									sentenciaStore.setInt("Par_UbicaNegocioID",Utileria.convierteEntero(cliente.getUbicaNegocioID()));

									sentenciaStore.setString("Par_FEA", clienteBean.getFea());
									sentenciaStore.setInt("Par_PaisFEA", Utileria.convierteEntero(clienteBean.getPaisFea()));
									sentenciaStore.setString("Par_FechaCons", (clienteBean.getFechaConstitucion() == null || clienteBean.getFechaConstitucion()=="") ? Constantes.FECHA_VACIA:clienteBean.getFechaConstitucion());

									//Campos adicionales para registro persona moral
									sentenciaStore.setInt("Par_PaisConstitucionID",Utileria.convierteEntero(cliente.getPaisConstitucionID()));
									sentenciaStore.setString("Par_CorreoAlterPM",cliente.getCorreoAlterPM());
									sentenciaStore.setString("Par_NombreNotario",cliente.getNombreNotario());
									sentenciaStore.setInt("Par_NumNotario",Utileria.convierteEntero(cliente.getNumNotario()));
									sentenciaStore.setString("Par_InscripcionReg",cliente.getInscripcionReg());
									sentenciaStore.setString("Par_EscrituraPubPM",cliente.getEscrituraPubPM());

									sentenciaStore.setInt("Par_PaisNacionalidad", Utileria.convierteEntero(cliente.getPaisNacionalidad()));
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_ClienteID", Types.INTEGER);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente: " + mensajeBean.getDescripcion());
								mensajeBean.setDescripcion("No es posible realizar la operación, el Cliente hizo coincidencia con la Listas de Personas Bloqueadas");
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	/* Modificacion del Cliente */
	public MensajeTransaccionBean modificaCliente(final ClienteBean cliente, final ClienteBean clienteBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
//								cliente.setTelefonoCelular(cliente.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
//								cliente.setTelefonoCasa(cliente.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
//								cliente.setTelTrabajo(cliente.getTelTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
//
									String query = "call CLIENTESMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cliente.getNumero()));
									sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(cliente.getSucursalOrigen()));
									sentenciaStore.setString("Par_TipoPersona",cliente.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",cliente.getTitulo());
									sentenciaStore.setString("Par_PrimerNom",cliente.getPrimerNombre());

									sentenciaStore.setString("Par_SegundoNom",cliente.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",cliente.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",cliente.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",cliente.getApellidoMaterno());
									sentenciaStore.setDate("Par_FechaNac",herramientas.OperacionesFechas.conversionStrDate(cliente.getFechaNacimiento()));

									sentenciaStore.setInt("Par_LugarNac",Utileria.convierteEntero(cliente.getLugarNacimiento()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(cliente.getEstadoID()));
									sentenciaStore.setString("Par_Nacion",clienteBean.getNacion());
									sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(cliente.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",cliente.getSexo());

									sentenciaStore.setString("Par_CURP",cliente.getCURP());
									sentenciaStore.setString("Par_RFC",cliente.getRFC());
									sentenciaStore.setString("Par_EstadoCivil",cliente.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",cliente.getTelefonoCelular());
									sentenciaStore.setString("Par_Telefono",clienteBean.getTelefonoCasa());

									sentenciaStore.setString("Par_Correo",clienteBean.getCorreo());
									sentenciaStore.setString("Par_RazonSocial",cliente.getRazonSocial());
									sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(cliente.getTipoSociedadID()));
									sentenciaStore.setString("Par_RFCpm",cliente.getRFCpm());
									sentenciaStore.setInt("Par_GrupoEmp",Utileria.convierteEntero(cliente.getGrupoEmpresarial()));

									sentenciaStore.setString("Par_Fax",cliente.getFax());
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(cliente.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",cliente.getPuesto());
									sentenciaStore.setString("Par_LugardeTrab",cliente.getLugarTrabajo());
									sentenciaStore.setDouble("Par_AntTra",Utileria.convierteDoble(cliente.getAntiguedadTra()));
									sentenciaStore.setString("Par_DomicilioTrabajo", cliente.getDomicilioTrabajo());

									sentenciaStore.setString("Par_TelTrabajo",cliente.getTelTrabajo());
									sentenciaStore.setString("Par_Clasific",cliente.getClasificacion());
									sentenciaStore.setString("Par_MotivoApert",cliente.getMotivoApertura());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());

									sentenciaStore.setString("Par_PagaIDE",cliente.getPagaIDE());
									sentenciaStore.setString("Par_NivelRiesgo",NivelBajo);
									sentenciaStore.setInt("Par_SecGeneral",Utileria.convierteEntero(cliente.getSectorGeneral()));
									sentenciaStore.setString("Par_ActBancoMX",cliente.getActividadBancoMX());
									sentenciaStore.setInt("Par_ActINEGI",Utileria.convierteEntero(cliente.getActividadINEGI()));

									sentenciaStore.setString("Par_ActFR",cliente.getActividadFR());
									sentenciaStore.setInt("Par_ActFOMUR",Utileria.convierteEntero(cliente.getActividadFOMUR()));
									sentenciaStore.setInt("Par_SecEconomic",Utileria.convierteEntero(cliente.getSectorEconomico()));
									sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(cliente.getPromotorInicial()));
									sentenciaStore.setInt("Par_PromotorAct",Utileria.convierteEntero(cliente.getPromotorActual()));

									//sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(cliente.getProspectoID()));
									sentenciaStore.setString("Par_EsMenorEdad",cliente.getEsMenorEdad());
									sentenciaStore.setInt("Par_CorpRelacionado",Utileria.convierteEntero(cliente.getCorpRelacionado()));
									sentenciaStore.setString("Par_RegistroHacienda",cliente.getRegistroHacienda());
									sentenciaStore.setInt("Par_NegocioAfiliadoID",Utileria.convierteEntero(cliente.getNegocioAfiliadoID()));
									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(cliente.getInstitNominaID()));

									sentenciaStore.setString("Par_Observaciones",cliente.getObservaciones());
									sentenciaStore.setString("Par_NoEmpleado",cliente.getNoEmpleado());
									sentenciaStore.setString("Par_TipoEmpleado",cliente.getTipoEmpleado());
									sentenciaStore.setString("Par_ExtTelefonoPart",clienteBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_ExtTelefonoTrab",cliente.getExtTelefonoTrab());

									sentenciaStore.setInt("Par_EjecutivoCap",Utileria.convierteEntero(cliente.getEjecutivoCap()));
									sentenciaStore.setInt("Par_PromotorExtInv",Utileria.convierteEntero(cliente.getPromotorExtInv()));
									sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(cliente.getTipoPuestoID()));
									sentenciaStore.setString("Par_FechaIniTrabajo",Utileria. convierteFecha(cliente.getFechaIniTrabajo()));
									sentenciaStore.setInt("Par_UbicaNegocioID",Utileria.convierteEntero(cliente.getUbicaNegocioID()));

									sentenciaStore.setString("Par_FEA", clienteBean.getFea());
									sentenciaStore.setInt("Par_PaisFEA", Utileria.convierteEntero(clienteBean.getPaisFea()));
									sentenciaStore.setString("Par_FechaCons", (clienteBean.getFechaConstitucion() == null || clienteBean.getFechaConstitucion()=="") ? Constantes.FECHA_VACIA:clienteBean.getFechaConstitucion());

									//Campos adicionales para registro persona moral
									sentenciaStore.setInt("Par_PaisConstitucionID",Utileria.convierteEntero(cliente.getPaisConstitucionID()));
									sentenciaStore.setString("Par_CorreoAlterPM",cliente.getCorreoAlterPM());
									sentenciaStore.setString("Par_NombreNotario",cliente.getNombreNotario());
									sentenciaStore.setInt("Par_NumNotario",Utileria.convierteEntero(cliente.getNumNotario()));
									sentenciaStore.setString("Par_InscripcionReg",cliente.getInscripcionReg());

									sentenciaStore.setString("Par_EscrituraPubPM",cliente.getEscrituraPubPM());
									sentenciaStore.setInt("Par_PaisNacionalidad", Utileria.convierteEntero(cliente.getPaisNacionalidad()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.modificaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.modificaCliente");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente: " + mensajeBean.getDescripcion());
								mensajeBean.setDescripcion("No es posible realizar la operación, el Cliente hizo coincidencia con la Listas de Personas Bloqueadas");
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public MensajeTransaccionBean modificaClienteReplica(final ClienteBean cliente, final ClienteBean clienteBean,final String origenReplica) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CLIENTESMOD(" +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?," +
																		"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cliente.getNumero()));
									sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(cliente.getSucursalOrigen()));
									sentenciaStore.setString("Par_TipoPersona",cliente.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",cliente.getTitulo());
									sentenciaStore.setString("Par_PrimerNom",cliente.getPrimerNombre());

									sentenciaStore.setString("Par_SegundoNom",cliente.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",cliente.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",cliente.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",cliente.getApellidoMaterno());
									sentenciaStore.setDate("Par_FechaNac",herramientas.OperacionesFechas.conversionStrDate(cliente.getFechaNacimiento()));

									sentenciaStore.setInt("Par_LugarNac",Utileria.convierteEntero(cliente.getLugarNacimiento()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(cliente.getEstadoID()));
									sentenciaStore.setString("Par_Nacion",clienteBean.getNacion());
									sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(cliente.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",cliente.getSexo());

									sentenciaStore.setString("Par_CURP",cliente.getCURP());
									sentenciaStore.setString("Par_RFC",cliente.getRFC());
									sentenciaStore.setString("Par_EstadoCivil",cliente.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",cliente.getTelefonoCelular());
									sentenciaStore.setString("Par_Telefono",clienteBean.getTelefonoCasa());

									sentenciaStore.setString("Par_Correo",clienteBean.getCorreo());
									sentenciaStore.setString("Par_RazonSocial",cliente.getRazonSocial());
									sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(cliente.getTipoSociedadID()));
									sentenciaStore.setString("Par_RFCpm",cliente.getRFCpm());
									sentenciaStore.setInt("Par_GrupoEmp",Utileria.convierteEntero(cliente.getGrupoEmpresarial()));

									sentenciaStore.setString("Par_Fax",cliente.getFax());
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(cliente.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",cliente.getPuesto());
									sentenciaStore.setString("Par_LugardeTrab",cliente.getLugarTrabajo());
									sentenciaStore.setDouble("Par_AntTra",Utileria.convierteDoble(cliente.getAntiguedadTra()));
									sentenciaStore.setString("Par_DomicilioTrabajo", cliente.getDomicilioTrabajo());

									sentenciaStore.setString("Par_TelTrabajo",cliente.getTelTrabajo());
									sentenciaStore.setString("Par_Clasific",cliente.getClasificacion());
									sentenciaStore.setString("Par_MotivoApert",cliente.getMotivoApertura());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());

									sentenciaStore.setString("Par_PagaIDE",cliente.getPagaIDE());
									sentenciaStore.setString("Par_NivelRiesgo",NivelBajo);
									sentenciaStore.setInt("Par_SecGeneral",Utileria.convierteEntero(cliente.getSectorGeneral()));
									sentenciaStore.setString("Par_ActBancoMX",cliente.getActividadBancoMX());
									sentenciaStore.setInt("Par_ActINEGI",Utileria.convierteEntero(cliente.getActividadINEGI()));

									sentenciaStore.setString("Par_ActFR",cliente.getActividadFR());
									sentenciaStore.setInt("Par_ActFOMUR",Utileria.convierteEntero(cliente.getActividadFOMUR()));
									sentenciaStore.setInt("Par_SecEconomic",Utileria.convierteEntero(cliente.getSectorEconomico()));
									sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(cliente.getPromotorInicial()));
									sentenciaStore.setInt("Par_PromotorAct",Utileria.convierteEntero(cliente.getPromotorActual()));

									sentenciaStore.setString("Par_EsMenorEdad",cliente.getEsMenorEdad());
									sentenciaStore.setInt("Par_CorpRelacionado",Utileria.convierteEntero(cliente.getCorpRelacionado()));
									sentenciaStore.setString("Par_RegistroHacienda",cliente.getRegistroHacienda());
									sentenciaStore.setInt("Par_NegocioAfiliadoID",Utileria.convierteEntero(cliente.getNegocioAfiliadoID()));
									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(cliente.getInstitNominaID()));

									sentenciaStore.setString("Par_Observaciones",cliente.getObservaciones());
									sentenciaStore.setString("Par_NoEmpleado",cliente.getNoEmpleado());
									sentenciaStore.setString("Par_TipoEmpleado",cliente.getTipoEmpleado());
									sentenciaStore.setString("Par_ExtTelefonoPart",clienteBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_ExtTelefonoTrab",cliente.getExtTelefonoTrab());

									sentenciaStore.setInt("Par_EjecutivoCap",Utileria.convierteEntero(cliente.getEjecutivoCap()));
									sentenciaStore.setInt("Par_PromotorExtInv",Utileria.convierteEntero(cliente.getPromotorExtInv()));
									sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(cliente.getTipoPuestoID()));
									sentenciaStore.setString("Par_FechaIniTrabajo",Utileria. convierteFecha(cliente.getFechaIniTrabajo()));
									sentenciaStore.setInt("Par_UbicaNegocioID",Utileria.convierteEntero(cliente.getUbicaNegocioID()));

									sentenciaStore.setString("Par_FEA", clienteBean.getFea());
									sentenciaStore.setInt("Par_PaisFEA", Utileria.convierteEntero(clienteBean.getPaisFea()));
									sentenciaStore.setString("Par_FechaCons", (clienteBean.getFechaConstitucion() == null || clienteBean.getFechaConstitucion()=="") ? Constantes.FECHA_VACIA:clienteBean.getFechaConstitucion());

									//Campos adicionales para registro persona moral
									sentenciaStore.setInt("Par_PaisConstitucionID",Utileria.convierteEntero(cliente.getPaisConstitucionID()));
									sentenciaStore.setString("Par_CorreoAlterPM",cliente.getCorreoAlterPM());
									sentenciaStore.setString("Par_NombreNotario",cliente.getNombreNotario());
									sentenciaStore.setInt("Par_NumNotario",Utileria.convierteEntero(cliente.getNumNotario()));
									sentenciaStore.setString("Par_InscripcionReg",cliente.getInscripcionReg());

									sentenciaStore.setString("Par_EscrituraPubPM",cliente.getEscrituraPubPM());
									sentenciaStore.setInt("Par_PaisNacionalidad", Utileria.convierteEntero(cliente.getPaisNacionalidad()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(origenReplica+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.modificaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.modificaCliente");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){
								loggerSAFI.error(origenReplica+"-"+"Error en Modificacion de Cliente: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(origenReplica+"-"+"Error en Modificacion de Cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/* Actualizacion de datos fiscales del cliente */

	  public MensajeTransaccionBean actualizaCliente(final ClienteBean cliente, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CLIENTESACT(?,?,?,?,?, ?,?,?,?,?, "
											                      + "?,?,?,?,?, ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cliente.getNumero()));
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIDE", cliente.getPagaIDE());
									sentenciaStore.setInt("Par_TipoInactiva", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_MotivoInactiva", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_PromotorNuevo", Utileria.convierteEntero(cliente.getPromotorActual()));
									sentenciaStore.setString("Par_UsuarioClave", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_ContraseniaAut", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClienteDAO.actualizaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClienteDAO.actualizaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar los datos fiscales del cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	  /*Actualización para activar / inactivar un Cliente */

	  public MensajeTransaccionBean activaInactivaCliente(final ClienteBean cliente, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIENTESACT(?,?,?,?,?, ?,?,?,?,?, "
					                                          + "?,?,?,?,?, ?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cliente.getNumero()));
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIDE", cliente.getPagaIDE());
									sentenciaStore.setString("Par_TipoInactiva", cliente.getTipoInactiva());
									sentenciaStore.setString("Par_MotivoInactiva",cliente.getMotivoInactiva());
									sentenciaStore.setInt("Par_PromotorNuevo", Utileria.convierteEntero(cliente.getPromotorActual()));
									sentenciaStore.setString("Par_UsuarioClave", cliente.getClaveUsuAuto());
									sentenciaStore.setString("Par_ContraseniaAut", cliente.getContraseniaUsu());
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setCampoGenerico(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClienteDAO.activaInactivaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClienteDAO.activaInactivaCliente");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}





		/* Consuta Cliente por Llave Principal*/
		public ClienteBean consultaPrincipal(int clienteID, int tipoConsulta) {
		ClienteBean clienteBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	clienteID,
									"",
									"",
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								ClienteBean cliente = new ClienteBean();
								cliente.setNumero(Utileria.completaCerosIzquierda(
		        						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
								cliente.setSucursalOrigen(resultSet.getString(2));
								cliente.setTipoPersona(resultSet.getString(3));
								cliente.setTitulo(resultSet.getString(4));
								cliente.setPrimerNombre(resultSet.getString(5));
								cliente.setSegundoNombre(resultSet.getString(6));
								cliente.setTercerNombre(resultSet.getString(7));
								cliente.setApellidoPaterno(resultSet.getString(8));
								cliente.setApellidoMaterno(resultSet.getString(9));
								cliente.setFechaNacimiento(resultSet.getString(10));
								cliente.setLugarNacimiento(String.valueOf(resultSet.getInt(11)));
								cliente.setEstadoID(resultSet.getString(12));
								cliente.setNacion(resultSet.getString(13));
								cliente.setPaisResidencia(resultSet.getString(14));
								cliente.setSexo(resultSet.getString(15));
								cliente.setCURP(resultSet.getString(16));
								cliente.setRFC(resultSet.getString(17));
								cliente.setEstadoCivil(resultSet.getString(18));
								cliente.setTelefonoCelular(resultSet.getString(19));
								cliente.setTelefonoCasa(resultSet.getString(20));
								cliente.setCorreo(resultSet.getString(21));
								cliente.setRazonSocial(resultSet.getString(22));
								cliente.setTipoSociedadID(String.valueOf(resultSet.getInt(23)));
								cliente.setRFCpm(resultSet.getString(24));
								cliente.setGrupoEmpresarial(resultSet.getString(25));
								cliente.setFax(resultSet.getString(26));
								cliente.setOcupacionID(resultSet.getString(27));
								cliente.setPuesto(resultSet.getString(28));
								cliente.setLugarTrabajo(resultSet.getString(29));
								cliente.setAntiguedadTra(resultSet.getString(30));
								cliente.setTelTrabajo(resultSet.getString(31));
								cliente.setClasificacion(resultSet.getString(32));
								cliente.setMotivoApertura(resultSet.getString(33));
								cliente.setPagaISR(resultSet.getString(34));
								cliente.setPagaIVA(resultSet.getString(35));
								cliente.setPagaIDE(resultSet.getString(36));
								cliente.setNivelRiesgo(resultSet.getString(37));
								cliente.setSectorGeneral(resultSet.getString(38));
								cliente.setActividadBancoMX(resultSet.getString(39));
								cliente.setActividadINEGI(resultSet.getString(40));
								cliente.setSectorEconomico(resultSet.getString(41));
								cliente.setPromotorInicial(resultSet.getString(42));
								cliente.setPromotorActual(resultSet.getString(43));
								cliente.setNombreCompleto(resultSet.getString(44));
								cliente.setActividadFR(resultSet.getString(45));
								cliente.setActividadFOMUR(resultSet.getString(46));
								cliente.setEstatus(resultSet.getString(47));
								cliente.setTipoInactiva(resultSet.getString(48));
								cliente.setMotivoInactiva(resultSet.getString(49));
								cliente.setEsMenorEdad(resultSet.getString(50));
								cliente.setCorpRelacionado(resultSet.getString(51));
								cliente.setCalificaCredito(resultSet.getString(52));
								cliente.setFechaAlta(resultSet.getString("FechaAlta"));
								cliente.setRegistroHacienda(resultSet.getString("RegistroHacienda"));
								cliente.setObservaciones(resultSet.getString("Observaciones"));

								cliente.setNoEmpleado(resultSet.getString("NoEmpleado"));
								cliente.setTipoEmpleado(resultSet.getString("TipoEmpleado"));
								cliente.setEdad(resultSet.getString("Edad"));
								cliente.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
								cliente.setExtTelefonoTrab(resultSet.getString("ExtTelefonoTrab"));
								cliente.setEjecutivoCap(resultSet.getString("EjecutivoCap"));
								cliente.setPromotorExtInv(resultSet.getString("PromotorExtInv"));
								cliente.setTipoPuestoID(resultSet.getString("TipoPuesto"));
								cliente.setFechaIniTrabajo(resultSet.getString("FechaIniTrabajo"));
								cliente.setUbicaNegocioID(resultSet.getString("UbicaNegocioID"));
								cliente.setFea(resultSet.getString("FEA"));
								cliente.setPaisFea(resultSet.getString("PaisFEA"));
								cliente.setFechaConstitucion(resultSet.getString("FechaConstitucion"));

								//personas morales
								cliente.setPaisConstitucionID(resultSet.getString("PaisConstitucionID"));
								cliente.setCorreoAlterPM(resultSet.getString("CorreoAlterPM"));
								cliente.setNombreNotario(resultSet.getString("NombreNotario"));
								cliente.setNumNotario(resultSet.getString("NumNotario"));
								cliente.setInscripcionReg(resultSet.getString("InscripcionReg"));
								cliente.setEscrituraPubPM(resultSet.getString("EscrituraPubPM"));

								cliente.setDomicilioTrabajo(resultSet.getString("DomicilioTrabajo"));
								cliente.setPaisNacionalidad(resultSet.getString("PaisNacionalidad"));
							return cliente;

						}
			});
			clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

		}
		return clienteBean;
		}


		/* Consuta Cliente utilizada en WS*/
		public ClienteBean consultaPrincipalWS(int clienteID, int tipoConsulta) {
			ClienteBean clienteBean = null;
			try{
				//Query con el Store Procedure
				String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	clienteID,
										"",
										"",
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ClienteDAO.consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
									};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");


				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									ClienteBean cliente = new ClienteBean();
									cliente.setNumero(Utileria.completaCerosIzquierda(
			        						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
									cliente.setSucursalOrigen(resultSet.getString(2));
									cliente.setTipoPersona(resultSet.getString(3));
									cliente.setTitulo(resultSet.getString(4));
									cliente.setPrimerNombre(resultSet.getString(5));
									cliente.setSegundoNombre(resultSet.getString(6));
									cliente.setTercerNombre(resultSet.getString(7));
									cliente.setApellidoPaterno(resultSet.getString(8));
									cliente.setApellidoMaterno(resultSet.getString(9));
									cliente.setFechaNacimiento(resultSet.getString(10));
									cliente.setLugarNacimiento(String.valueOf(resultSet.getInt(11)));
									cliente.setEstadoID(resultSet.getString(12));
									cliente.setNacion(resultSet.getString(13));
									cliente.setPaisResidencia(resultSet.getString(14));
									cliente.setSexo(resultSet.getString(15));
									cliente.setCURP(resultSet.getString(16));
									cliente.setRFC(resultSet.getString(17));
									cliente.setEstadoCivil(resultSet.getString(18));
									cliente.setTelefonoCelular(resultSet.getString(19));
									cliente.setTelefonoCasa(resultSet.getString(20));
									cliente.setCorreo(resultSet.getString(21));
									cliente.setRazonSocial(resultSet.getString(22));
									cliente.setTipoSociedadID(String.valueOf(resultSet.getInt(23)));
									cliente.setRFCpm(resultSet.getString(24));
									cliente.setGrupoEmpresarial(resultSet.getString(25));
									cliente.setFax(resultSet.getString(26));
									cliente.setOcupacionID(resultSet.getString(27));
									cliente.setPuesto(resultSet.getString(28));
									cliente.setLugarTrabajo(resultSet.getString(29));
									cliente.setAntiguedadTra(resultSet.getString(30));
									cliente.setTelTrabajo(resultSet.getString(31));
									cliente.setClasificacion(resultSet.getString(32));
									cliente.setMotivoApertura(resultSet.getString(33));
									cliente.setPagaISR(resultSet.getString(34));
									cliente.setPagaIVA(resultSet.getString(35));
									cliente.setPagaIDE(resultSet.getString(36));
									cliente.setNivelRiesgo(resultSet.getString(37));
									cliente.setSectorGeneral(resultSet.getString(38));
									cliente.setActividadBancoMX(resultSet.getString(39));
									cliente.setActividadINEGI(resultSet.getString(40));
									cliente.setSectorEconomico(resultSet.getString(41));
									cliente.setPromotorInicial(resultSet.getString(42));
									cliente.setPromotorActual(resultSet.getString(43));
									cliente.setNombreCompleto(resultSet.getString(44));
									cliente.setActividadFR(resultSet.getString(45));
									cliente.setActividadFOMUR(resultSet.getString(46));
									cliente.setEstatus(resultSet.getString(47));
									cliente.setTipoInactiva(resultSet.getString(48));
									cliente.setMotivoInactiva(resultSet.getString(49));
									cliente.setEsMenorEdad(resultSet.getString(50));
									cliente.setCorpRelacionado(resultSet.getString(51));
									cliente.setCalificaCredito(resultSet.getString(52));
									cliente.setFechaAlta(resultSet.getString("FechaAlta"));
									cliente.setRegistroHacienda(resultSet.getString("RegistroHacienda"));
									cliente.setObservaciones(resultSet.getString("Observaciones"));

									cliente.setNoEmpleado(resultSet.getString("NoEmpleado"));
									cliente.setTipoEmpleado(resultSet.getString("TipoEmpleado"));
									cliente.setEdad(resultSet.getString("Edad"));
									cliente.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
									cliente.setExtTelefonoTrab(resultSet.getString("ExtTelefonoTrab"));
									cliente.setEjecutivoCap(resultSet.getString("EjecutivoCap"));
									cliente.setPromotorExtInv(resultSet.getString("PromotorExtInv"));
									cliente.setTipoPuestoID(resultSet.getString("TipoPuesto"));
									cliente.setFechaIniTrabajo(resultSet.getString("FechaIniTrabajo"));
									cliente.setUbicaNegocioID(resultSet.getString("UbicaNegocioID"));


								return cliente;

							}
				});
				clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
			}catch(Exception e){

				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

			}
			return clienteBean;
			}

	/* Consuta Cliente por Llave Principal*/
	public ClienteBean consultaPrincipalOpeInusuales(int clienteID, int tipoConsulta, String OrigenDatos) {
	ClienteBean clienteBean = null;
	try{
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(OrigenDatos)).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ClienteBean cliente = new ClienteBean();
							cliente.setNumero(Utileria.completaCerosIzquierda(
	        						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
							cliente.setSucursalOrigen(resultSet.getString(2));
							cliente.setTipoPersona(resultSet.getString(3));
							cliente.setTitulo(resultSet.getString(4));
							cliente.setPrimerNombre(resultSet.getString(5));
							cliente.setSegundoNombre(resultSet.getString(6));
							cliente.setTercerNombre(resultSet.getString(7));
							cliente.setApellidoPaterno(resultSet.getString(8));
							cliente.setApellidoMaterno(resultSet.getString(9));
							cliente.setFechaNacimiento(resultSet.getString(10));
							cliente.setLugarNacimiento(String.valueOf(resultSet.getInt(11)));
							cliente.setEstadoID(resultSet.getString(12));
							cliente.setNacion(resultSet.getString(13));
							cliente.setPaisResidencia(resultSet.getString(14));
							cliente.setSexo(resultSet.getString(15));
							cliente.setCURP(resultSet.getString(16));
							cliente.setRFC(resultSet.getString(17));
							cliente.setEstadoCivil(resultSet.getString(18));
							cliente.setTelefonoCelular(resultSet.getString(19));
							cliente.setTelefonoCasa(resultSet.getString(20));
							cliente.setCorreo(resultSet.getString(21));
							cliente.setRazonSocial(resultSet.getString(22));
							cliente.setTipoSociedadID(String.valueOf(resultSet.getInt(23)));
							cliente.setRFCpm(resultSet.getString(24));
							cliente.setGrupoEmpresarial(resultSet.getString(25));
							cliente.setFax(resultSet.getString(26));
							cliente.setOcupacionID(resultSet.getString(27));
							cliente.setPuesto(resultSet.getString(28));
							cliente.setLugarTrabajo(resultSet.getString(29));
							cliente.setAntiguedadTra(resultSet.getString(30));
							cliente.setTelTrabajo(resultSet.getString(31));
							cliente.setClasificacion(resultSet.getString(32));
							cliente.setMotivoApertura(resultSet.getString(33));
							cliente.setPagaISR(resultSet.getString(34));
							cliente.setPagaIVA(resultSet.getString(35));
							cliente.setPagaIDE(resultSet.getString(36));
							cliente.setNivelRiesgo(resultSet.getString(37));
							cliente.setSectorGeneral(resultSet.getString(38));
							cliente.setActividadBancoMX(resultSet.getString(39));
							cliente.setActividadINEGI(resultSet.getString(40));
							cliente.setSectorEconomico(resultSet.getString(41));
							cliente.setPromotorInicial(resultSet.getString(42));
							cliente.setPromotorActual(resultSet.getString(43));
							cliente.setNombreCompleto(resultSet.getString(44));
							cliente.setActividadFR(resultSet.getString(45));
							cliente.setActividadFOMUR(resultSet.getString(46));
							cliente.setEstatus(resultSet.getString(47));
							cliente.setTipoInactiva(resultSet.getString(48));
							cliente.setMotivoInactiva(resultSet.getString(49));
							cliente.setEsMenorEdad(resultSet.getString(50));
							cliente.setCorpRelacionado(resultSet.getString(51));
							cliente.setCalificaCredito(resultSet.getString(52));
							cliente.setFechaAlta(resultSet.getString("FechaAlta"));
							cliente.setRegistroHacienda(resultSet.getString("RegistroHacienda"));
							cliente.setObservaciones(resultSet.getString("Observaciones"));

							cliente.setNoEmpleado(resultSet.getString("NoEmpleado"));
							cliente.setTipoEmpleado(resultSet.getString("TipoEmpleado"));
							cliente.setEdad(resultSet.getString("Edad"));
							cliente.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
							cliente.setExtTelefonoTrab(resultSet.getString("ExtTelefonoTrab"));
							cliente.setEjecutivoCap(resultSet.getString("EjecutivoCap"));
							cliente.setPromotorExtInv(resultSet.getString("PromotorExtInv"));
							cliente.setTipoPuestoID(resultSet.getString("TipoPuesto"));


						return cliente;

					}
		});
		clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

	}
	return clienteBean;
	}

	public ClienteBean consultaForanea(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));

					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}

	public ClienteBean consultaTipoPersona(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setTipoPersona(resultSet.getString(3));
				return cliente;
			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}

	public ClienteBean consultaProspectoCliente(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setProspectoID(String.valueOf(resultSet.getInt(2)));

				return cliente;
			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}


	public ClienteBean consultaParaEnvioCorreo(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setCorreo(resultSet.getString(3));

					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}


	/* Consulta para obtener calificacion y clasificacion del cliente */
	public ClienteBean consultaCalificacion(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
				cliente.setCalificaCredito(resultSet.getString("CalificaCredito"));
				cliente.setCalificacion(resultSet.getString("Calificacion"));
				cliente.setPagaIVA(resultSet.getString("PagaIVA"));
				cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));

			return cliente;
			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}
	// consulta nombre estatus y si es menor de edad para el grid de grupos no solidarios
	public ClienteBean consultaDatosGrid(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
				cliente.setEstatus(resultSet.getString("Estatus"));
				cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
				cliente.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}

	/* Lista de Clientes por Nombre */
	public List listaPrincipal(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ClienteDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
				resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}

	/* Lista de Clientes por Nombre */
	public List listaPriExterna(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(clienteBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
				resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}

	public List listaPrincipalVentanilla(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Utileria.convierteEntero(clienteBean.getClienteID()),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setDireccion(resultSet.getString(3));
				cliente.setNombSucursal(resultSet.getString(4));
				return cliente;
			}
		});
		return matches;
	}

	/* Lista de Clientes por Nombre */
	public List listaCorpRelacionado(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}

	/* Lista de Clientes por Nombre */
	public List listaCorpRelacionadoBotones(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setDireccion(resultSet.getString(3));
				return cliente;
			}
		});
		return matches;
	}
	//valida que el RFC del cliente no exista ya en la bd
	public ClienteBean validaClienteRFC(String RFC, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?)";
		Object[] parametros = {	0,
								RFC,
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setRFCOficial(resultSet.getString(2));
				return cliente;
			}
		});

		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}
	//valida que el CURP del cliente no exista ya en la bd
		public ClienteBean validaClienteCURP(String CURP, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?)";
			Object[] parametros = {	0,
									"",
									CURP,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClienteBean cliente = new ClienteBean();
					cliente.setNumero(Utileria.completaCerosIzquierda(
							resultSet.getInt(1),ClienteBean.LONGITUD_ID));
					cliente.setCURP(resultSet.getString(2));
					cliente.setTipoPersona(resultSet.getString(3));
					return cliente;
				}
			});

			return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
		}


	/* Consulta para la pantallas externas(cuentaPersona) */
	public ClienteBean consultaOtraPantalla(int clienteID, int tipoConsulta) {
		ClienteBean clienteBean= null;
			try{
			  //Query con el Store Procedure
	        String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
	        Object[] parametros = {        clienteID,
	                                       "",
	                                       "",
	                                       tipoConsulta,
	                                       Constantes.ENTERO_CERO,
	       								   Constantes.ENTERO_CERO,
	       								   Constantes.FECHA_VACIA,
	       								   Constantes.STRING_VACIO,
	       								   "ClienteDAO.consultaPrincipal",
	       								   Constantes.ENTERO_CERO,
	       								   Constantes.ENTERO_CERO};
	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
	                public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
	                        ClienteBean cliente = new ClienteBean();

	                        cliente.setNumero(Utileria.completaCerosIzquierda(
	        						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
	                        cliente.setNombreCompleto(resultSet.getString(2));
	                        cliente.setRazonSocial(resultSet.getString(3));
	                        cliente.setTipoPersona(resultSet.getString(4));
	                        cliente.setRFC(resultSet.getString(5));
	                        cliente.setTelefonoCasa(resultSet.getString(6));
	                        cliente.setSucursalOrigen(resultSet.getString(7));
	                        cliente.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
	                        cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
	                        cliente.setEstatus(resultSet.getString("Estatus"));
	                        return cliente;

	                }
	        }); clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	        	}catch(Exception e){
	        		e.printStackTrace();
	        		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta de clientes",e);
	        	}
			return clienteBean;
	}


	/* Consulta para Pantallas de Inversiones */
	public ClienteBean consultaParaInversiones(int clienteID, int tipoConsulta) {
        //Query con el Store Procedure
        String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
        Object[] parametros = {
        		   clienteID,
        		   Constantes.STRING_VACIO,
        		   Constantes.STRING_VACIO,
                   tipoConsulta,
                   Constantes.ENTERO_CERO,

                   Constantes.ENTERO_CERO,
				   Constantes.FECHA_VACIA,
				   Constantes.STRING_VACIO,
				   "ClienteDAO.consultaPrincipal",
				   Constantes.ENTERO_CERO,
				   Constantes.ENTERO_CERO};
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
                public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                        ClienteBean cliente = new ClienteBean();

                        cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
                        cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
                        cliente.setTelefonoCasa(resultSet.getString("Telefono"));
                        cliente.setPagaISR(resultSet.getString("PagaISR"));
                        cliente.setClasificacion(resultSet.getString("Clasificacion"));
                        cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
                        cliente.setCalificaCredito(resultSet.getString("CalificaCredito"));
                        cliente.setTasaISR(resultSet.getString("TasaISR"));
                        return cliente;
                }
        });
        return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}

	public ClienteBean consultaAportaciones(final int clienteID, final int tipoConsulta){
		ClienteBean cteBean = null;
		try {
			cteBean = (ClienteBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CLIENTESCON("
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID",clienteID);
							sentenciaStore.setString("Par_RFC",Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_CURP",Constantes.STRING_VACIO);
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							ClienteBean cliente = new ClienteBean();
							if(callableStatement.execute()){
								ResultSet resultSet = callableStatement.getResultSet();

								resultSet.next();
								cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
								cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
								cliente.setTelefonoCasa(resultSet.getString("Telefono"));
								cliente.setPagaISR(resultSet.getString("PagaISR"));
								cliente.setClasificacion(resultSet.getString("Clasificacion"));
								cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
								cliente.setCalificaCredito(resultSet.getString("CalificaCredito"));
								cliente.setTasaISR(resultSet.getString("TasaISR"));
								cliente.setPaisResidencia(resultSet.getString("PaisResidencia"));
								cliente.setValidaTasa(resultSet.getString("ValidaTasa"));
							}
							return cliente;
						}
					});
			return cteBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de clientes para aportaciones: ", e);
			return null;
		}
	}

	/* Consulta para la pantalla de resumen de cliente */
	public ClienteBean consultaResumenCte(int clienteID, int tipoConsulta) {
        //Query con el Store Procedure
        String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
        Object[] parametros = {
        		clienteID,
        		Constantes.STRING_VACIO,
        		Constantes.STRING_VACIO,
        		tipoConsulta,
        		Constantes.ENTERO_CERO,
        		Constantes.ENTERO_CERO,
        		Constantes.FECHA_VACIA,
        		Constantes.STRING_VACIO,
        		"ClienteDAO.consultaResumenCte",
        		Constantes.ENTERO_CERO,
        		Constantes.ENTERO_CERO
        		};
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
            public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                    ClienteBean cliente = new ClienteBean();

                    cliente.setNumero(Utileria.completaCerosIzquierda(
    						resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
                    cliente.setTipoPersona(resultSet.getString("TipoPersona"));
                    cliente.setPromotorActual(String.valueOf(resultSet.getInt("PromotorActual")));
                    cliente.setSucursalOrigen(String.valueOf(resultSet.getInt("SucursalOrigen")));
                    cliente.setFechaAlta(resultSet.getString("FechaAlta"));
                    cliente.setTipoSociedadID(String.valueOf(resultSet.getInt("TipoSociedadID")));
                    cliente.setGrupoEmpresarial(String.valueOf(resultSet.getInt("GrupoEmpresarial")));
                    cliente.setSexo(resultSet.getString("Sexo"));
                    cliente.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
                    cliente.setNacion(resultSet.getString("Nacion"));
                    cliente.setEstadoCivil(resultSet.getString("EstadoCivil"));
                    cliente.setTelefonoCasa(resultSet.getString("Telefono"));
                    cliente.setCorreo(resultSet.getString("Correo"));
                    cliente.setActividadBancoMX(resultSet.getString("ActividadBancoMX"));
                    cliente.setActividadINEGI(String.valueOf(resultSet.getInt("ActividadINEGI")));
                    cliente.setSectorEconomico(String.valueOf(resultSet.getInt("SectorEconomico")));
                    cliente.setOcupacionID(String.valueOf(resultSet.getInt("OcupacionID")));
                    cliente.setPuesto(resultSet.getString("Puesto"));
                    cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
                    cliente.setRFC(resultSet.getString("RFC"));
                    cliente.setEstatus(resultSet.getString("Estatus"));
                    return cliente;
            }
        });
        return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
}


	/* Consulta para la pantalla de solicitud apoyo escolar */
	public ClienteBean consultaCliente(int clienteID, int tipoConsulta) {
        String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
        Object[] parametros = {
        		clienteID,
        		Constantes.STRING_VACIO,
        		Constantes.STRING_VACIO,
        		tipoConsulta,
        		Constantes.ENTERO_CERO,
        		Constantes.ENTERO_CERO,
        		Constantes.FECHA_VACIA,
        		Constantes.STRING_VACIO,
        		"ClienteDAO.consultaCliente",
        		Constantes.ENTERO_CERO,
        		Constantes.ENTERO_CERO
        		};
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
            public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                    ClienteBean cliente = new ClienteBean();

                    cliente.setNumero(Utileria.completaCerosIzquierda(
    				resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
                    cliente.setTipoPersona(resultSet.getString("TipoPersona"));
                    cliente.setSucursalOrigen(String.valueOf(resultSet.getInt("SucursalOrigen")));
                    cliente.setFechaAlta(resultSet.getString("FechaAlta"));
                    cliente.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
                    cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
                    cliente.setRFC(resultSet.getString("RFC"));
                    cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
                    cliente.setEdad(resultSet.getString("Edad"));
                    return cliente;
            }
        });
        return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
}


	/*Consulta para pantalla de pago de credito (incluye si paga IVA)*/
	public ClienteBean consultaPagoCredito(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPagoCredito",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setPagaIVA(resultSet.getString(3));
					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}

	//forma RFC del cliente
	public ClienteBean formaClienteRFC(ClienteBean cliente) {
		//Query con el Store Procedure
		String query = "call CLIENTERFCCAL(?,?,?,?)";
		Object[] parametros = {cliente.getPrimerNombre(),
							   cliente.getApellidoPaterno(),
						       cliente.getApellidoMaterno(),
						       OperacionesFechas.conversionStrDate(cliente.getFechaNacimiento())};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTERFCCAL(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setRFC(resultSet.getString(1));
				return cliente;
			}
		});

		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}



	/* obteniendo la forma de la curp del Cliente */
	public ClienteBean formaClienteCURP(final ClienteBean cliente) {

		ClienteBean clienteBeanResultado = new ClienteBean();
		clienteBeanResultado = (ClienteBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ClienteBean clientrebeanTransaccion = new ClienteBean();
				try {
					// Query con el Store Procedure
					clientrebeanTransaccion = (ClienteBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CLIENTECURPCAL(?,?,?,?,? ,?,?,?,?,? ,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_PrimerNombre",	cliente.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNombre",	cliente.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre",	cliente.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",		cliente.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",		cliente.getApellidoMaterno());
									sentenciaStore.setString("Par_Genero",			cliente.getSexo());
									sentenciaStore.setString("Par_FecNac",		cliente.getFechaNacimiento());
									sentenciaStore.setString("Par_EsExtranjero",	cliente.getNacion());
									sentenciaStore.setInt("Par_EntidadFed",	Utileria.convierteEntero(cliente.getEstadoID()));


									sentenciaStore.registerOutParameter("Par_CURP", Types.VARCHAR);
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {

									ClienteBean clientedao = new ClienteBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										clientedao.setNumero(			(resultadosStore.getString(1)));
										clientedao.setCURP(			resultadosStore.getString(2));
										clientedao.setNumTransaccion(	resultadosStore.getString(3));
										clientedao.setNombreCompleto(	resultadosStore.getString(4));

									}
									return clientedao;
								}
							}
							);


					} catch (Exception e) {

						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al obtener la forma de la curp", e);
					}
					return clientrebeanTransaccion;
				}
			});


			return clienteBeanResultado;
		}


	/* Lista dClientese Clientes para SMS */
	public List listaSMS(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setTelefonoCelular(resultSet.getString(3));
				return cliente;
			}
		});
		return matches;
	}
	/* Lista dClientese Clientes para SMS */
	public List listaSMSBotones(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				cliente.setTelefonoCelular(resultSet.getString(3));
				cliente.setDireccion(resultSet.getString(4));
				return cliente;
			}
		});
		return matches;
	}

	public   ClienteBean consultaCorpRel(int corpRelacionado, int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCOORPCON(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {	corpRelacionado,
								clienteID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SolicitudTarDebDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCOORPCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));

					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}
	/* Lista de Clientes relacionados al Coorporativo*/
	public List listaClienteRelCorp(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESCOORPLIS(?,?,?, ?,?,? ,?,?,?,?);";
		Object[] parametros = {
								clienteBean.getClienteID(),
								Utileria.convierteEntero(clienteBean.getCorpRelacionado()),

								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCOORPLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}

	/* Lista de Clientes por Nombre para requerimiento SEIDO */
	public List listaSeido(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								clienteBean.getClienteID(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(resultSet.getString("ClienteID"));
				cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
				cliente.setSucursal(resultSet.getString("Sucursal"));
				cliente.setEstatus(resultSet.getString("Estatus"));
				cliente.setFechaAlta(resultSet.getString("FechaAlta"));
				cliente.setFechaCorte(resultSet.getString("FechaBaja"));
				cliente.setDireccion(resultSet.getString("DireccionCompleta"));
				cliente.setLugarNacimiento(resultSet.getString("LugarNacimiento"));
				cliente.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				cliente.setCURP(resultSet.getString("CURP"));
				cliente.setRFC(resultSet.getString("RFC"));
				cliente.setOcupacionID(resultSet.getString("Ocupacion"));
				return cliente;
			}
		});
		return matches;
	}


	/* Lista de Clientes tipo Persona Moral */
	public List listaClienteMoral(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString("RazonSocial"));
				cliente.setDireccion(resultSet.getString("Direccion"));
				return cliente;
			}
		});
		return matches;
	}


	/*Consulta de Estatus de los creditos de un cliente retorna la cantidad de estatus que esta vigentes o vencidos)*/
	public ClienteBean consultaEstatusCred(ClienteBean clienteBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getClienteID(),
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaEstatusCred",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setEstatusCred(resultSet.getString(1));
					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}
	//Consulta de Clientes para carga de archivos de pagos de nomina
	public ClienteBean consultaClienteWS(ClienteBean clienteBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(clienteBean.getClienteID()),
								"",
								"",
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaClienteWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();

				cliente.setClienteID(Utileria.completaCerosIzquierda(
						resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
				cliente.setPrimerNombre(resultSet.getString("PrimerNombre"));
				cliente.setSegundoNombre(resultSet.getString("SegundoNombre"));
				cliente.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				cliente.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				cliente.setCorreo(resultSet.getString("Correo"));
				cliente.setTelefonoCelular(resultSet.getString("TelefonoCelular"));



					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}


	public   ClienteBean consultaNombreCliente(ClienteBean clienteBean) {
		//Query con el Store Procedure
		String query = "call CLIENTESWSCON(?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(clienteBean.getClienteID()),
								Utileria.convierteEntero(clienteBean.getInstitucionNominaID()),
								Utileria.convierteEntero(clienteBean.getNegocioAfiliadoID()),
								Utileria.convierteEntero(clienteBean.getNumCon()),


								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaNombre",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESWSCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
					cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}




/* Consulta para validar la curp y el estatus del cliente */
public ClienteBean consultaCURPESTATUS(int clienteID, int tipoConsulta) {
	ClienteBean clienteBean= null;
		try{
		  //Query con el Store Procedure
        String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
        Object[] parametros = {        clienteID,
                                       "",
                                       "",
                                       tipoConsulta,
                                       Constantes.ENTERO_CERO,
       								   Constantes.ENTERO_CERO,
       								   Constantes.FECHA_VACIA,
       								   Constantes.STRING_VACIO,
       								   "ClienteDAO.consultaCURPESTAUS",
       								   Constantes.ENTERO_CERO,
       								   Constantes.ENTERO_CERO};
        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
                public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                        ClienteBean cliente = new ClienteBean();
                        cliente.setNumero(Utileria.completaCerosIzquierda(
        						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
                        cliente.setCURP(resultSet.getString(2));
                        cliente.setDescripcionCURP(resultSet.getString(3));
                        cliente.setDescripcionRFC(resultSet.getString(4));

                        return cliente;

                }
        }); clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
        	}catch(Exception e){
        		e.printStackTrace();
        		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta de Validación de CURP y Estatus",e);
        	}
		return clienteBean;
}
	//consulta los datos generales del cliente
	public ClienteBean consultaDatosGenerales(int clienteID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setMoroso(resultSet.getString("Mora"));
				cliente.setMaximoMora(resultSet.getString("MaximoMora"));
				cliente.setTotalAhorro(resultSet.getString("SaldoTotCtas"));
				cliente.setTotalCreditos(resultSet.getString("AdeudoTotal"));
				cliente.setTotalInversion(resultSet.getString("MontoInversiones"));

				cliente.setNumero(Integer.toString(Constantes.ENTERO_CERO));

				return cliente;

			}
		});
		return matches.size() > 0 ? (ClienteBean) matches.get(0) : null;

	}

	public ClienteBean consultaTarDebEntura(int clienteID, int tipoConsulta) {
	ClienteBean clienteBean = null;
	try{
		//Query con el Store Procedure
		String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClienteBean cliente = new ClienteBean();
					cliente.setNumero(resultSet.getString("ClienteID"));
					cliente.setCURP(resultSet.getString("CURP"));
					cliente.setTipoDocumento(resultSet.getString("TipoDocumento"));
					cliente.setPrimerNombre(resultSet.getString("NombresCliente")); // Se utiliza para guardar los nombres del cliente
					cliente.setApellidoPaterno(resultSet.getString("ApellidosCliente")); // Se utiliza para guardar los apellidos del cliente
					cliente.setCodigoMoneda(resultSet.getString("CodMoneda"));
					cliente.setDireccion(resultSet.getString("DirecCliente"));
					cliente.setTipoDireccion(resultSet.getString("TipoDireccion"));
					cliente.setCorreo(resultSet.getString("Correo"));
					cliente.setTelefonoCasa(resultSet.getString("Telefono"));
					cliente.setTipoTelefono(resultSet.getString("TipoTelefono"));
					cliente.setEstadoCivil(resultSet.getString("EstadoCivil"));
					cliente.setSexo(resultSet.getString("Genero"));
					cliente.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					cliente.setCodCooperativa(resultSet.getString("CodCooperativa"));
					cliente.setCodMoneda(resultSet.getString("CodMoneda"));
					cliente.setCodUsuario(resultSet.getString("CodUsuario"));
					cliente.setTipoCuenta(resultSet.getString("TipoCuenta"));
					return cliente;
			}
		});
		clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

	}
	return clienteBean;
	}

	// Consulta para saber el nivel de riego que tiene el Cliente, usado en Conocimiento del Cliente
	public ClienteBean consultaConocimientoCte(int clienteID, int tipoConsulta) {
		ClienteBean clienteBean = null;
		try{
			//Query con el Store Procedure
			String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	clienteID,
									"",
									"",
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClienteDAO.consultaNivelRiesgoCte",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClienteBean cliente = new ClienteBean();
						cliente.setNumero(resultSet.getString("ClienteID"));
						cliente.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
						cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
                        cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
                        cliente.setNacion(resultSet.getString("Nacion"));
                        cliente.setActividadBancoMX(resultSet.getString("ActividadBancoMX"));

						return cliente;
				}
			});
			clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" Error en la consulta de nievel de riesgo del cliente: ", e);
		}
		return clienteBean;
	}

	// Consulta para saber los clientes que son personas físicas
		public ClienteBean consultaClientePersonaFisica(int clienteID, int tipoConsulta) {
			ClienteBean clienteBean = null;
			try{
				//Query con el Store Procedure
				String query = "call CLIENTESCON(?,?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	clienteID,
										"",
										"",
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ClienteDAO.consultaClientePersonaFisica",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
									};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCON(" + Arrays.toString(parametros) + ");");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ClienteBean cliente = new ClienteBean();
							cliente.setNumero(resultSet.getString("ClienteID"));
							cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));

							return cliente;
					}
				});
				clienteBean= matches.size() > 0 ? (ClienteBean) matches.get(0) : null;
			} catch(Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" Error en la consulta del cliente: ", e);
			}
			return clienteBean;
		}

	/* ********************************METODOS QUE  MARCAN ERROR EN QA   */


	// Lista de Clientes por Nombre WS
	public List listaClienteWS(ListaClienteRequest listaClienteRequest, int tipoLista) {
		final ListaClienteResponse mensajeBean = new ListaClienteResponse();
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,	?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {

								listaClienteRequest.getNombre(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.listaClienteWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setClienteID(resultSet.getString("ClienteID"));
				cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return cliente;
			}
		});
		return matches;
	}



	// Lista de Clientes por Nombre deacuerdo al perfil  para banca en linea
	public List listaClienteBEWS(ListaClientesBERequest listaClienteRequest) {
			//Query con el Store Procedure
		String query = "call CLIENTESWSLIS(?,?,?,?,	 ?,?,?,?,?,?,?,?);";
		Object[] parametros = {	listaClienteRequest.getNombre(),
								Utileria.convierteEntero(listaClienteRequest.getInstitNominaID()),
								Utileria.convierteEntero(listaClienteRequest.getNegocioAfiliadoID()),
								Utileria.convierteEntero(listaClienteRequest.getNumLis()),
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.listaClienteWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESWSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setClienteID(resultSet.getString("ClienteID"));
				cliente.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return cliente;
			}
		});
		return matches;
	}


	/* Lista de Clientes por Nombre */
	public List listaCtePorSucural(ClienteBean clienteBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTESLIS(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getClienteID(),
								clienteBean.getSucursalID(),
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteBean cliente = new ClienteBean();
				cliente.setNumero(Utileria.completaCerosIzquierda(
				resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				cliente.setNombreCompleto(resultSet.getString(2));
				return cliente;
			}
		});
		return matches;
	}



	/* Actualizacion de Promotor del cliente */

	  public MensajeTransaccionBean actualizaPromotorActual(final ClienteBean cliente, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CLIENTESACT(?,?,?,?,?, ?,?,?,?,?, "
											                      + "?,?,?,?,?, ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cliente.getNumero()));
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIDE", cliente.getPagaIDE());
									sentenciaStore.setInt("Par_TipoInactiva", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_MotivoInactiva", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_PromotorNuevo", Utileria.convierteEntero(cliente.getPromotorNue()));
									sentenciaStore.setString("Par_UsuarioClave", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_ContraseniaAut", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClienteDAO.actualizaPromotorActual");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ClienteDAO.actualizaPromotorActual");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el promotor actual del cliente" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
