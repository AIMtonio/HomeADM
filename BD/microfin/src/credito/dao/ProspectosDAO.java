package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;





import tesoreria.bean.CuentaNostroBean;
import credito.bean.ProspectosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;



import cliente.bean.NegocioAfiliadoBean;
import cliente.dao.NegocioAfiliadoDAO;
import cliente.bean.EmpleadoNominaBean;
import cliente.dao.EmpleadoNominaDAO;
import credito.beanWS.request.ListaProspectoRequest;
import credito.beanWS.response.ConsultaProspectoResponse;
import credito.beanWS.response.ListaProspectoResponse;

public class ProspectosDAO extends BaseDAO{
	public ProspectosDAO() {
		super();
	}

	EmpleadoNominaDAO empleadoDAO= null;
	NegocioAfiliadoDAO negocioDAO = null;

		// Alta de Prospecto
		public MensajeTransaccionBean altaProspecto(final ProspectosBean prospectosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						if(prospectosBean.getTelefono()!=null){
							prospectosBean.setTelefono(prospectosBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
						}
						if(prospectosBean.getTelTrabajo()!=null){
							prospectosBean.setTelTrabajo(prospectosBean.getTelTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
						}
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PROSPECTOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?," +
													  				  "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?," +
													  				  "?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProspectoIDExt",Utileria.convierteEntero(prospectosBean.getProspectoIDExt()));
									sentenciaStore.setString("Par_PrimerNom",prospectosBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom",prospectosBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",prospectosBean.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",prospectosBean.getApellidoPaterno());

									sentenciaStore.setString("Par_ApellidoMat",prospectosBean.getApellidoMaterno());
									sentenciaStore.setString("Par_Telefono",prospectosBean.getTelefono());
									sentenciaStore.setString("Par_Calle",prospectosBean.getCalle());
									sentenciaStore.setString("Par_NumExterior",prospectosBean.getNumExterior());
									sentenciaStore.setString("Par_NumInterior",prospectosBean.getNumInterior());

									sentenciaStore.setString("Par_Colonia",prospectosBean.getColonia());
									sentenciaStore.setString("Par_Manzana",prospectosBean.getManzana());
									sentenciaStore.setString("Par_Lote",prospectosBean.getLote());
									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(prospectosBean.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(prospectosBean.getColoniaID()));

									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(prospectosBean.getMunicipioID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(prospectosBean.getEstadoID()));
									sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(prospectosBean.getCP()));
									sentenciaStore.setString("Par_TipoPersona",prospectosBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial",prospectosBean.getRazonSocial());

									sentenciaStore.setDate("Par_FechaNacimiento", OperacionesFechas.conversionStrDate(prospectosBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_RFC",prospectosBean.getRFC());
									sentenciaStore.setString("Par_Sexo",prospectosBean.getSexo());
									sentenciaStore.setString("Par_EstadoCivil",prospectosBean.getEstadoCivil());
									sentenciaStore.setString("Par_Latitud",prospectosBean.getLatitud());

									sentenciaStore.setString("Par_Longitud",prospectosBean.getLongitud());
									sentenciaStore.setInt("Par_TipoDireccionID",Utileria.convierteEntero(prospectosBean.getTipoDireccionID()));
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(prospectosBean.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",prospectosBean.getPuesto());
									sentenciaStore.setString("Par_LugarTrabajo",prospectosBean.getLugarTrabajo());

									sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(prospectosBean.getAntiguedadTra()));
									sentenciaStore.setString("Par_TelTrabajo",prospectosBean.getTelTrabajo());
									sentenciaStore.setString("Par_Clasificacion",prospectosBean.getClasificacion());
									sentenciaStore.setString("Par_NoEmpleado",prospectosBean.getNoEmpleado());
									sentenciaStore.setString("Par_TipoEmpleado",prospectosBean.getTipoEmpleado());

									sentenciaStore.setString("Par_RFCpm",prospectosBean.getRFCpm());
									sentenciaStore.setString("Par_ExtTelefonoPart",prospectosBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_ExtTelefonoTrab",prospectosBean.getExtTelefonoTrab());
									sentenciaStore.setString("Par_Nacion",prospectosBean.getNacion());
									sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(prospectosBean.getLugarNacimiento()));
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(prospectosBean.getPaisResidenciaID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if (mensajeBean.getNumero() == 50 ) { // Error que corresponde cuando se detecta en lista de pers bloqueadas o  de paises de la gafi
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Prospecto: " + mensajeBean.getDescripcion());

							mensajeBean.setDescripcion("No es posible realizar la operación, el prospecto hizo coincidencia con la Listas de Personas Bloqueadas");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del prospecto ", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

  public MensajeTransaccionBean altaProspectWS(final ProspectosBean prospectos) {
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
							String query = "call PROSPECTOSWSALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
															   +"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,"
							   								   +"?,?,?,?,?,	?,?,?,?,?);";

							if(prospectos.getTelefono()!=null){
								prospectos.setTelefono(prospectos.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							}
							if(prospectos.getTelTrabajo()!=null){
								prospectos.setTelTrabajo(prospectos.getTelTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							}

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(prospectos.getInstitucionNominaID()));
							sentenciaStore.setInt("Par_NegocioAfiliadoID", Utileria.convierteEntero(prospectos.getNegocioAfiliadoID()));
							sentenciaStore.setLong("Par_ProspectoIDExt", Utileria.convierteLong(prospectos.getProspectoIDExt()));
							sentenciaStore.setString("Par_PrimerNom", prospectos.getPrimerNombre());
							sentenciaStore.setString("Par_SegundoNom", prospectos.getSegundoNombre());
							sentenciaStore.setString("Par_TercerNom", prospectos.getTercerNombre());
							sentenciaStore.setString("Par_ApellidoPat", prospectos.getApellidoPaterno());
							sentenciaStore.setString("Par_ApellidoMat", prospectos.getApellidoMaterno());
							sentenciaStore.setString("Par_Telefono", prospectos.getTelefono());
							sentenciaStore.setString("Par_Calle", prospectos.getCalle());
							sentenciaStore.setString("Par_NumExterior", prospectos.getNumExterior());
							sentenciaStore.setString("Par_NumInterior", prospectos.getNumInterior());

							sentenciaStore.setString("Par_Colonia", prospectos.getColonia());
							sentenciaStore.setString("Par_Manzana", prospectos.getManzana());
							sentenciaStore.setString("Par_Lote", prospectos.getLote());
							sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(prospectos.getLocalidadID()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(prospectos.getColoniaID()));
							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(prospectos.getMunicipioID()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(prospectos.getEstadoID()));
							sentenciaStore.setString("Par_CP", prospectos.getCP());
							sentenciaStore.setString("Par_TipoPersona", prospectos.getTipoPersona());
							sentenciaStore.setString("Par_RazonSocial", prospectos.getRazonSocial());

							sentenciaStore.setDate("Par_FechaNacimiento", OperacionesFechas.conversionStrDate(prospectos.getFechaNacimiento()));
							sentenciaStore.setString("Par_RFC", prospectos.getRFC());
							sentenciaStore.setString("Par_Sexo", prospectos.getSexo());
							sentenciaStore.setString("Par_EstadoCivil", prospectos.getEstadoCivil());
							sentenciaStore.setString("Par_Latitud", prospectos.getLatitud());
							sentenciaStore.setString("Par_Longitud", prospectos.getLongitud());
							sentenciaStore.setInt("Par_TipoDireccionID", Utileria.convierteEntero(prospectos.getTipoDireccionID()));
							sentenciaStore.setInt("Par_OcupacionID", Utileria.convierteEntero(prospectos.getOcupacionID()));
							sentenciaStore.setString("Par_Puesto", prospectos.getPuesto());
							sentenciaStore.setString("Par_LugarTrabajo", prospectos.getLugarTrabajo());

							sentenciaStore.setString("Par_AntiguedadTra", prospectos.getAntiguedadTra());
							sentenciaStore.setString("Par_TelTrabajo", prospectos.getTelTrabajo());
							sentenciaStore.setString("Par_Clasificacion", prospectos.getClasificacion());
							sentenciaStore.setString("Par_NoEmpleado", prospectos.getNoEmpleado());
							sentenciaStore.setString("Par_TipoEmpleado", prospectos.getTipoEmpleado());
							sentenciaStore.setString("Par_RFCpm", prospectos.getRFCpm());
							sentenciaStore.setString("Par_ExtTelefonoPart", prospectos.getExtTelefonoPart());
							sentenciaStore.setString("Par_ExtTelefonoTrab", prospectos.getExtTelefonoTrab());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.altaCuentaNostro");
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
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProspectosDAO.altaProspectWS");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ProspectosDAO.altaProspectWS");
					}else if(mensajeBean.getNumero()!=0){
						if (mensajeBean.getNumero() == 50 ) { // Error que corresponde cuando se detecta en lista de pers bloqueadas o  de paises de la gafi
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Prospecto: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de alta el prospecto " + e);
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

	// Modificacion de Prospecto
	public MensajeTransaccionBean modificacionProspecto(final ProspectosBean prospectosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					if(prospectosBean.getTelefono()!=null){
						prospectosBean.setTelefono(prospectosBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					}
					if(prospectosBean.getTelTrabajo()!=null){
						prospectosBean.setTelTrabajo(prospectosBean.getTelTrabajo().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					}
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PROSPECTOSMOD(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	" +
																  "?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(prospectosBean.getProspectoID()));
								sentenciaStore.setString("Par_PrimerNom",prospectosBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",prospectosBean.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",prospectosBean.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat",prospectosBean.getApellidoPaterno());

								sentenciaStore.setString("Par_ApellidoMat",prospectosBean.getApellidoMaterno());
								sentenciaStore.setString("Par_Telefono",prospectosBean.getTelefono());
								sentenciaStore.setString("Par_Calle",prospectosBean.getCalle());
								sentenciaStore.setString("Par_NumExterior",prospectosBean.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",prospectosBean.getNumInterior());

								sentenciaStore.setString("Par_Manzana",prospectosBean.getManzana());
								sentenciaStore.setString("Par_Lote",prospectosBean.getLote());
								sentenciaStore.setString("Par_Colonia",prospectosBean.getColonia());
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(prospectosBean.getColoniaID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(prospectosBean.getLocalidadID()));

								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(prospectosBean.getMunicipioID()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(prospectosBean.getEstadoID()));
								sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(prospectosBean.getCP()));
								sentenciaStore.setString("Par_TipoPersona",prospectosBean.getTipoPersona());
								sentenciaStore.setString("Par_RazonSocial",prospectosBean.getRazonSocial());

								sentenciaStore.setDate("Par_FechaNacimiento", OperacionesFechas.conversionStrDate(prospectosBean.getFechaNacimiento()));
								sentenciaStore.setString("Par_RFC",prospectosBean.getRFC());
								sentenciaStore.setString("Par_Sexo",prospectosBean.getSexo());
								sentenciaStore.setString("Par_EstadoCivil",prospectosBean.getEstadoCivil());
								sentenciaStore.setString("Par_Latitud",prospectosBean.getLatitud());

								sentenciaStore.setString("Par_Longitud",prospectosBean.getLongitud());
								sentenciaStore.setInt("Par_TipoDireccionID",Utileria.convierteEntero(prospectosBean.getTipoDireccionID()));
								sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(prospectosBean.getOcupacionID()));
								sentenciaStore.setString("Par_Puesto",prospectosBean.getPuesto());
								sentenciaStore.setString("Par_LugarTrabajo",prospectosBean.getLugarTrabajo());

								sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(prospectosBean.getAntiguedadTra()));
								sentenciaStore.setString("Par_TelTrabajo",prospectosBean.getTelTrabajo());
								sentenciaStore.setString("Par_Clasificacion",prospectosBean.getClasificacion());
								sentenciaStore.setString("Par_NoEmpleado",prospectosBean.getNoEmpleado());
								sentenciaStore.setString("Par_TipoEmpleado",prospectosBean.getTipoEmpleado());

								sentenciaStore.setString("Par_RFCpm",prospectosBean.getRFCpm());
								sentenciaStore.setString("Par_ExtTelefonoPart",prospectosBean.getExtTelefonoPart());
								sentenciaStore.setString("Par_ExtTelefonoTrab",prospectosBean.getExtTelefonoTrab());
								sentenciaStore.setString("Par_Nacion",prospectosBean.getNacion());
								sentenciaStore.setInt("Par_LugarNacimiento", Utileria.convierteEntero(prospectosBean.getLugarNacimiento()));
								sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(prospectosBean.getPaisResidenciaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							if (mensajeBean.getNumero() == 50 ) { // Error que corresponde cuando se detecta en lista de pers bloqueadas o  de paises de la gafi
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Prospecto: " + mensajeBean.getDescripcion());
								mensajeBean.setDescripcion("No es posible realizar la operación, el prospecto hizo coincidencia con la Listas de Personas Bloqueadas");
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del proyecto", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// Modificacion de Prospecto WS
		public MensajeTransaccionBean modificacionProspectoWS(final ProspectosBean prospectosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final int paisNoEspecificado = 999;
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PROSPECTOSMOD(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	" +
																	  "?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,	?,?,?,?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(prospectosBean.getProspectoID()));
									sentenciaStore.setString("Par_PrimerNom",prospectosBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom",prospectosBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",prospectosBean.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",prospectosBean.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",prospectosBean.getApellidoMaterno());
									sentenciaStore.setString("Par_Telefono",prospectosBean.getTelefono());
									sentenciaStore.setString("Par_Calle",prospectosBean.getCalle());
									sentenciaStore.setString("Par_NumExterior",prospectosBean.getNumExterior());
									sentenciaStore.setString("Par_NumInterior",prospectosBean.getNumInterior());

									sentenciaStore.setString("Par_Manzana",prospectosBean.getManzana());
									sentenciaStore.setString("Par_Lote",prospectosBean.getLote());
									sentenciaStore.setString("Par_Colonia",prospectosBean.getColonia());
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(prospectosBean.getColoniaID()));
									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(prospectosBean.getLocalidadID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(prospectosBean.getMunicipioID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(prospectosBean.getEstadoID()));
									sentenciaStore.setInt("Par_CP",Utileria.convierteEntero(prospectosBean.getCP()));
									sentenciaStore.setString("Par_TipoPersona",prospectosBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial",prospectosBean.getRazonSocial());

									sentenciaStore.setDate("Par_FechaNacimiento", OperacionesFechas.conversionStrDate(prospectosBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_RFC",prospectosBean.getRFC());
									sentenciaStore.setString("Par_Sexo",prospectosBean.getSexo());
									sentenciaStore.setString("Par_EstadoCivil",prospectosBean.getEstadoCivil());
									sentenciaStore.setString("Par_Latitud",prospectosBean.getLatitud());
									sentenciaStore.setString("Par_Longitud",prospectosBean.getLongitud());
									sentenciaStore.setInt("Par_TipoDireccionID",Utileria.convierteEntero(prospectosBean.getTipoDireccionID()));
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(prospectosBean.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",prospectosBean.getPuesto());
									sentenciaStore.setString("Par_LugarTrabajo",prospectosBean.getLugarTrabajo());

									sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(prospectosBean.getAntiguedadTra()));
									sentenciaStore.setString("Par_TelTrabajo",prospectosBean.getTelTrabajo());
									sentenciaStore.setString("Par_Clasificacion",prospectosBean.getClasificacion());
									sentenciaStore.setString("Par_NoEmpleado",prospectosBean.getNoEmpleado());
									sentenciaStore.setString("Par_TipoEmpleado",prospectosBean.getTipoEmpleado());
									sentenciaStore.setString("Par_RFCpm",prospectosBean.getRFCpm());
									sentenciaStore.setString("Par_ExtTelefonoPart",prospectosBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_ExtTelefonoTrab",prospectosBean.getExtTelefonoTrab());
									sentenciaStore.setInt("Par_PaisID", paisNoEspecificado);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							if (mensajeBean.getNumero() == 50 ) { // Error que corresponde cuando se detecta en lista de pers bloqueadas o  de paises de la gafi
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Prospecto: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del prospecto ", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
	//Consulta principal de Prospecto
	public ProspectosBean consultaPrincipal(ProspectosBean prospectosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PROSPECTOSCON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
								Utileria.convierteEntero(prospectosBean.getCliente()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProspectosBean prospectosBean = new ProspectosBean();
				prospectosBean.setProspectoID(String.valueOf(resultSet.getLong("ProspectoID")));
				prospectosBean.setTipoPersona(resultSet.getString(		"TipoPersona"));
				prospectosBean.setRazonSocial(resultSet.getString(		"RazonSocial"));
				prospectosBean.setPrimerNombre(resultSet.getString(		"PrimerNombre"));
				prospectosBean.setSegundoNombre(resultSet.getString(	"SegundoNombre"));
				prospectosBean.setTercerNombre(resultSet.getString(		"TercerNombre"));
				prospectosBean.setApellidoPaterno(resultSet.getString(	"ApellidoPaterno"));
				prospectosBean.setApellidoMaterno(resultSet.getString(	"ApellidoMaterno"));
				prospectosBean.setFechaNacimiento(resultSet.getString(	"FechaNacimiento"));
				prospectosBean.setRFC(resultSet.getString("RFC"));
				prospectosBean.setSexo(resultSet.getString("Sexo"));
				prospectosBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				prospectosBean.setTelefono(resultSet.getString("Telefono"));
				prospectosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				prospectosBean.setCalle(resultSet.getString("Calle"));
				prospectosBean.setNumExterior(resultSet.getString("NumExterior"));
				prospectosBean.setNumInterior(resultSet.getString("NumInterior"));
				prospectosBean.setManzana(resultSet.getString("Manzana"));
				prospectosBean.setLote(resultSet.getString("Lote"));
				prospectosBean.setColonia(resultSet.getString("Colonia"));
				prospectosBean.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));
				prospectosBean.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
				prospectosBean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				prospectosBean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));
				prospectosBean.setCP(resultSet.getString("CP"));
				prospectosBean.setCliente(resultSet.getString("ClienteID"));
				prospectosBean.setLatitud(resultSet.getString("Latitud"));
				prospectosBean.setLongitud(resultSet.getString("Longitud"));
				prospectosBean.setTipoDireccionID(resultSet.getString("TipoDireccionID"));
				prospectosBean.setOcupacionID(resultSet.getString("OcupacionID"));
				prospectosBean.setLugarTrabajo(resultSet.getString("LugardeTrabajo"));
				prospectosBean.setPuesto(resultSet.getString("Puesto"));
				prospectosBean.setTelTrabajo(resultSet.getString("TelTrabajo"));
				prospectosBean.setAntiguedadTra(resultSet.getString("AntiguedadTra"));
				prospectosBean.setClasificacion(resultSet.getString("Clasificacion"));
				prospectosBean.setNoEmpleado(resultSet.getString("NoEmpleado"));
				prospectosBean.setTipoEmpleado(resultSet.getString("TipoEmpleado"));
				prospectosBean.setRFCpm(resultSet.getString("RFCpm"));
				prospectosBean.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
				prospectosBean.setExtTelefonoTrab(resultSet.getString("ExtTelefonoTrab"));
				prospectosBean.setCalificaProspectos(resultSet.getString("CalificaProspecto"));
				prospectosBean.setNacion(resultSet.getString("Nacion"));
				prospectosBean.setLugarNacimiento(resultSet.getString("LugarNacimiento"));
				prospectosBean.setPaisResidenciaID(resultSet.getString("PaisID"));
				prospectosBean.setPaisResidencia(resultSet.getString("Nombre"));
				return prospectosBean;
			}
		});
		return matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
	}

	//Consulta foranea de Prospecto
	public ProspectosBean consultaForanea(ProspectosBean prospectosBean, int tipoConsulta) {
		ProspectosBean prospectosBeanConsulta = new ProspectosBean();
		try{
			//Query con el Store Procedure
			String query = "call PROSPECTOSCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
									Utileria.convierteEntero(prospectosBean.getCliente()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProspectosBean prospectosBean = new ProspectosBean();
					prospectosBean.setProspectoID(Utileria.completaCerosIzquierda(resultSet.getString(1),10));
					prospectosBean.setNombreCompleto(resultSet.getString(2));
					prospectosBean.setCliente(resultSet.getString(3));
					prospectosBean.setSexo(resultSet.getString("Sexo"));
					prospectosBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
					return prospectosBean;
				}
			});
			prospectosBeanConsulta= matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta foranea del prospect", e);
		}
		return prospectosBeanConsulta;
	}


	//Consulta principal de Prospecto
	public ProspectosBean consultaProspectoPorCliente(ProspectosBean prospectosBean, int tipoConsulta) {
		ProspectosBean prospectosBeanConsulta = new ProspectosBean();
		try{
			//Query con el Store Procedure
			String query = "call PROSPECTOSCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
									Utileria.convierteEntero(prospectosBean.getCliente()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProspectosBean prospectosBean = new ProspectosBean();
					prospectosBean.setProspectoID(Utileria.completaCerosIzquierda(resultSet.getString(1),10));
					prospectosBean.setNombreCompleto(resultSet.getString(2));
					prospectosBean.setCliente(resultSet.getString(3));
					return prospectosBean;
				}
			});
			prospectosBeanConsulta= matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal del prospecto", e);
		}
		return prospectosBeanConsulta;
	}


	public List listaPrincipal(ProspectosBean prospectos, int tipoLista){

		String query = "call PROSPECTOSLIS(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
					prospectos.getProspectoID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProspectosBean prospectos = new ProspectosBean();
				prospectos.setProspectoID(String.valueOf(resultSet.getString(1)));
				prospectos.setNombreCompleto(resultSet.getString(2));
				return prospectos;
			}
		});
		return matches;
	}


	//alta de prospectos para Banca En Linea
		public MensajeTransaccionBean altaProspectoBanca(final ProspectosBean prospectos, final long numeroTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			final int paisNoEspecificado = 999;
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						String query = "call PROSPECTOSALT(" +
								"?,?,?,?,?, ?,?,?,?,?," +
								"?,?,?,?,?, ?,?,?,?,?," +
								"?,?,?,?,?,	?,?,?,?,?," +
								"?,?,?,?,?, ?,?,?,?,?," +
								"?,?,?,?,?,	?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteEntero(prospectos.getProspectoIDExt()),
								prospectos.getPrimerNombre(),
								prospectos.getSegundoNombre(),
								prospectos.getTercerNombre(),
								prospectos.getApellidoPaterno(),

								prospectos.getApellidoMaterno(),
								prospectos.getTelefono(),
								prospectos.getCalle(),
								prospectos.getNumExterior(),
								prospectos.getNumInterior(),

								prospectos.getColonia(),
								prospectos.getManzana(),
								prospectos.getLote(),
								Utileria.convierteEntero(prospectos.getLocalidadID()),
								Utileria.convierteEntero(prospectos.getColoniaID()),

								Utileria.convierteEntero(prospectos.getMunicipioID()),
								Utileria.convierteEntero(prospectos.getEstadoID()),
								Utileria.convierteEntero(prospectos.getCP()),
								prospectos.getTipoPersona(),
								prospectos.getRazonSocial(),

								OperacionesFechas.conversionStrDate(prospectos.getFechaNacimiento()),
								prospectos.getRFC(),
								prospectos.getSexo(),
								prospectos.getEstadoCivil(),
								prospectos.getLatitud(),

								prospectos.getLongitud(),
								Utileria.convierteEntero(prospectos.getTipoDireccionID()),
								Utileria.convierteEntero(prospectos.getOcupacionID()),
								prospectos.getPuesto(),
								prospectos.getLugarTrabajo(),

								prospectos.getAntiguedadTra(),
								prospectos.getTelTrabajo(),
								prospectos.getClasificacion(),
								prospectos.getNoEmpleado(),
								prospectos.getTipoEmpleado(),

								prospectos.getRFCpm(),
								prospectos.getExtTelefonoPart(),
								prospectos.getExtTelefonoTrab(),

								paisNoEspecificado,

								Constantes.STRING_SI,
								Types.INTEGER,
								Types.VARCHAR,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ProspectosDAO.altaProspectoBanca",
								parametrosAuditoriaBean.getSucursal(),
								numeroTransaccion
						};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSALT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum)
									throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
								mensaje.setConsecutivoString(resultSet.getString(4));

								return mensaje;
							}
						});
						return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(99);
						}
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas Y PAISES DE LA GAFI
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Cliente: " + mensajeBean.getDescripcion());
						} else {
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Prospectos", e);
						}
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	//Consulta principal de Prospecto
	public ProspectosBean consultaCalificacionProspectos(ProspectosBean prospectosBean, int tipoConsulta) {
		ProspectosBean prospectosBeanConsulta = new ProspectosBean();
		try{
			//Query con el Store Procedure
			String query = "call PROSPECTOSCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProspectosBean prospectosBean = new ProspectosBean();
					prospectosBean.setCalificaProspectos(resultSet.getString(1));
					return prospectosBean;
				}
			});
			prospectosBeanConsulta= matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal del prospecto", e);
		}
		return prospectosBeanConsulta;
	}
	//Consulta NombreCompleto del prospecto
	public ProspectosBean consultaNombreProspecto(ProspectosBean prospectosBean, int tipoConsulta) {
		ProspectosBean prospectosBeanConsulta = new ProspectosBean();
		try{
			//Query con el Store Procedure
			String query = "call PROSPECTOSWSCON(?,?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
									Utileria.convierteEntero(prospectosBean.getInstitucionNominaID()),
									Utileria.convierteEntero(prospectosBean.getNegocioAfiliadoID()),
									Utileria.convierteEntero(prospectosBean.getNumCon()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProspectosBean prospectosBean = new ProspectosBean();
					prospectosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					prospectosBean.setCalificaProspectos(resultSet.getString("CalificaProspecto"));
					return prospectosBean;
				}
			});
			prospectosBeanConsulta= matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de nombre del prospecto", e);
		}
		return prospectosBeanConsulta;
	}


	//Consulta a los prospectos que son Persona Fisica y Fisica con Actividad Empresarial
		public ProspectosBean consultaProspectoPF(ProspectosBean prospectosBean, int tipoConsulta) {
			ProspectosBean prospectosBeanConsulta = new ProspectosBean();
			try{
				//Query con el Store Procedure
				String query = "call PROSPECTOSCON(?,?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
										Constantes.ENTERO_CERO,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ProspectosBean prospectosBean = new ProspectosBean();

						prospectosBean.setProspectoID(resultSet.getString("ProspectoID"));
						prospectosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						return prospectosBean;
					}
				});
				prospectosBeanConsulta= matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal del prospecto", e);
			}
			return prospectosBeanConsulta;
		}
	// metodo para realizar un alta de Prospecto En Banca En Linea(manda a llamar el alta en la tabla NOMINAEMPLEADOS o NEGAFILICLIENTE)
		public MensajeTransaccionBean altaProspectoWS(final ProspectosBean prospectos){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					MensajeTransaccionBean mensajeProspecto = new MensajeTransaccionBean();
					try {
						mensajeProspecto = altaProspectoBanca(prospectos,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeProspecto.getNumero()!=0){
								throw new Exception(mensajeProspecto.getDescripcion());
							}
							// Se compara si es una Institución de Nomina o un Negocio Afiliado para hacer el alta en la
							// tabla correspondiente
								if(Utileria.convierteEntero(prospectos.getInstitucionNominaID())!= 0){

										EmpleadoNominaBean empleadoBean= new EmpleadoNominaBean();

										empleadoBean.setInstitNominaID(prospectos.getInstitucionNominaID());
										empleadoBean.setProspectoID(mensajeProspecto.getConsecutivoString());

										mensajeBean= empleadoDAO.altaEmpleadoNominaBanca(empleadoBean, parametrosAuditoriaBean.getNumeroTransaccion());

										if(mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion());
										}

									}else if(Utileria.convierteEntero(prospectos.getNegocioAfiliadoID())!= 0) {
										NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();

										negocioBean.setNegocioAfiliadoID(prospectos.getNegocioAfiliadoID());
										negocioBean.setProspectoID(mensajeProspecto.getConsecutivoString());

										mensajeBean= negocioDAO.altaNegAfilClienteBanca(negocioBean,parametrosAuditoriaBean.getNumeroTransaccion());
										if(mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion());
										}

									}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Registro de Prospecto Correctamente.");

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion(e.getMessage());
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Prospectos BE", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	public List listaProspectoWS(ListaProspectoRequest listaProspectoRequest){
		final ListaProspectoResponse mensajeBean = new ListaProspectoResponse();
		String query = "call PROSPECTOSWSLIS(?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {

				listaProspectoRequest.getNombreCompleto(),
				Utileria.convierteEntero(listaProspectoRequest.getInstitNominaID()),
				Utileria.convierteEntero(listaProspectoRequest.getNegocioAfiliadoID()),
				Utileria.convierteEntero(listaProspectoRequest.getTipoLis()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProspectosDAO.listaProspectoWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSWSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProspectosBean lisProspecto = new ProspectosBean();

				lisProspecto.setProspectoID(String.valueOf(resultSet.getInt("ProspectoID")));
				lisProspecto.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return lisProspecto;

			}
		});
		return matches;
	}
	//Consulta principal de Prospecto WS

	public ProspectosBean consultaPrincipalWS(ProspectosBean prospectosBean, int tipoConsulta) {
			final ConsultaProspectoResponse mensajeBean = new ConsultaProspectoResponse();
			String query = "call PROSPECTOSWSCON(?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(prospectosBean.getProspectoID()),
									Utileria.convierteEntero(prospectosBean.getInstitucionNominaID()),
									prospectosBean.getNegocioAfiliadoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROSPECTOSWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProspectosBean prospectosBean = new ProspectosBean();
					prospectosBean.setProspectoID(String.valueOf(resultSet.getLong("ProspectoID")));
					prospectosBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
					prospectosBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
					prospectosBean.setTercerNombre(resultSet.getString("TercerNombre"));
					prospectosBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));

					prospectosBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					prospectosBean.setTipoPersona(resultSet.getString("TipoPersona"));
					prospectosBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					prospectosBean.setRFC(resultSet.getString("RFC"));
					prospectosBean.setSexo(resultSet.getString("Sexo"));

					prospectosBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
					prospectosBean.setTelefono(resultSet.getString("Telefono"));
					prospectosBean.setRazonSocial(resultSet.getString("RazonSocial"));
					prospectosBean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));
					prospectosBean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));

					prospectosBean.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
					prospectosBean.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));
					prospectosBean.setCalle(resultSet.getString("Calle"));
					prospectosBean.setNumExterior(resultSet.getString("NumExterior"));
					prospectosBean.setNumInterior(resultSet.getString("NumInterior"));

					prospectosBean.setCP(resultSet.getString("CP"));
					prospectosBean.setManzana(resultSet.getString("Manzana"));
					prospectosBean.setLote(resultSet.getString("Lote"));
					prospectosBean.setLatitud(resultSet.getString("Latitud"));
					prospectosBean.setLongitud(resultSet.getString("Longitud"));

					prospectosBean.setTipoDireccionID(String.valueOf(resultSet.getInt("TipoDireccionID")));
					prospectosBean.setCalificaProspectos(resultSet.getString("CalificaProspecto"));

					prospectosBean.setNumErr(resultSet.getString("NumErr"));
					prospectosBean.setErrMen(resultSet.getString("ErrMen"));

					return prospectosBean;
				}
			});
			return matches.size() > 0 ? (ProspectosBean) matches.get(0) : null;
		}

	public EmpleadoNominaDAO getEmpleadoDAO() {
		return empleadoDAO;
	}

	public void setEmpleadoDAO(EmpleadoNominaDAO empleadoDAO) {
		this.empleadoDAO = empleadoDAO;
	}

	public NegocioAfiliadoDAO getNegocioDAO() {
		return negocioDAO;
	}

	public void setNegocioDAO(NegocioAfiliadoDAO negocioDAO) {
		this.negocioDAO = negocioDAO;
	}

}
