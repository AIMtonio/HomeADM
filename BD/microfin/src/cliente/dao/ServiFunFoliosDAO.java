package cliente.dao;

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

import ventanilla.bean.IngresosOperacionesBean;
import cliente.bean.ServiFunFoliosBean;
import cliente.bean.ServifunFoliosRepBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ServiFunFoliosDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	public ServiFunFoliosDAO() {
		super();
	}

	/* Alta de un registro de ServiFunFolios */
	public MensajeTransaccionBean altaRegistro(final ServiFunFoliosBean serviFunFoliosBean) {
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
								String query = "call SERVIFUNFOLIOSALT(?,?,?,?,?,	?,?,?,?,?,	"
																	+ "?,?,?,?,?,	?,?,?,?,?,"
																	+ "?,?,?,?,?,	?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(serviFunFoliosBean.getClienteID()));
								sentenciaStore.setString("Par_TipoServicio",serviFunFoliosBean.getTipoServicio());
								sentenciaStore.setInt("Par_DifunClienteID",Utileria.convierteEntero(serviFunFoliosBean.getDifunClienteID()));
								sentenciaStore.setString("Par_DifunPrimerNombre",serviFunFoliosBean.getDifunPrimerNombre());
								sentenciaStore.setString("Par_DifunSegundoNombre",serviFunFoliosBean.getDifunSegundoNombre());

								sentenciaStore.setString("Par_DifunTercerNombre",serviFunFoliosBean.getDifunTercerNombre());
								sentenciaStore.setString("Par_DifunApePaterno",serviFunFoliosBean.getDifunApePaterno());
								sentenciaStore.setString("Par_DifunApeMaterno",serviFunFoliosBean.getDifunApeMaterno());
								sentenciaStore.setDate("Par_DifunFechaNacim",OperacionesFechas.conversionStrDate(serviFunFoliosBean.getDifunFechaNacim()));
								sentenciaStore.setInt("Par_DifunParentesco",Utileria.convierteEntero(serviFunFoliosBean.getDifunParentesco()));

								sentenciaStore.setInt("Par_TramClienteID",Utileria.convierteEntero(serviFunFoliosBean.getTramClienteID()));
								sentenciaStore.setString("Par_TramPrimerNombre",serviFunFoliosBean.getTramPrimerNombre());
								sentenciaStore.setString("Par_TramSegundoNombre",serviFunFoliosBean.getTramSegundoNombre());
								sentenciaStore.setString("Par_TramTercerNombre",serviFunFoliosBean.getTramTercerNombre());
								sentenciaStore.setString("Par_TramApePaterno",serviFunFoliosBean.getTramApePaterno());

								sentenciaStore.setString("Par_TramApeMaterno",serviFunFoliosBean.getTramApeMaterno());
								sentenciaStore.setString("Par_TramFechaNacim",Utileria.convierteFecha(serviFunFoliosBean.getTramFechaNacim()));
								sentenciaStore.setInt("Par_TramParentesco",Utileria.convierteEntero(serviFunFoliosBean.getTramParentesco()));
								sentenciaStore.setString("Par_NoCertificadoDefun",serviFunFoliosBean.getNoCertificadoDefun());
								sentenciaStore.setDate("Par_FechaCertiDefun",OperacionesFechas.conversionStrDate(serviFunFoliosBean.getFechaCertiDefun()));

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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error ServiFunFolios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaServiFunFolios(final ServiFunFoliosBean serviFunFoliosBean) {
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
								String query = "call SERVIFUNFOLIOSMOD(?,?,?,?,?,	?,?,?,?,?,	"
																	+ "?,?,?,?,?,	?,?,?,?,?,"
																	+ "?,?,?,?,?,	?,?,?,?,?,"
																	+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServiFunFolioID",Utileria.convierteEntero(serviFunFoliosBean.getServiFunFolioID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(serviFunFoliosBean.getClienteID()));
								sentenciaStore.setString("Par_TipoServicio",serviFunFoliosBean.getTipoServicio());
								sentenciaStore.setInt("Par_DifunClienteID",Utileria.convierteEntero(serviFunFoliosBean.getDifunClienteID()));
								sentenciaStore.setString("Par_DifunPrimerNombre",serviFunFoliosBean.getDifunPrimerNombre());
								sentenciaStore.setString("Par_DifunSegundoNombre",serviFunFoliosBean.getDifunSegundoNombre());

								sentenciaStore.setString("Par_DifunTercerNombre",serviFunFoliosBean.getDifunTercerNombre());
								sentenciaStore.setString("Par_DifunApePaterno",serviFunFoliosBean.getDifunApePaterno());
								sentenciaStore.setString("Par_DifunApeMaterno",serviFunFoliosBean.getDifunApeMaterno());
								sentenciaStore.setDate("Par_DifunFechaNacim",OperacionesFechas.conversionStrDate(serviFunFoliosBean.getDifunFechaNacim()));
								sentenciaStore.setInt("Par_DifunParentesco",Utileria.convierteEntero(serviFunFoliosBean.getDifunParentesco()));

								sentenciaStore.setInt("Par_TramClienteID",Utileria.convierteEntero(serviFunFoliosBean.getTramClienteID()));
								sentenciaStore.setString("Par_TramPrimerNombre",serviFunFoliosBean.getTramPrimerNombre());
								sentenciaStore.setString("Par_TramSegundoNombre",serviFunFoliosBean.getTramSegundoNombre());
								sentenciaStore.setString("Par_TramTercerNombre",serviFunFoliosBean.getTramTercerNombre());
								sentenciaStore.setString("Par_TramApePaterno",serviFunFoliosBean.getTramApePaterno());

								sentenciaStore.setString("Par_TramApeMaterno",serviFunFoliosBean.getTramApeMaterno());
								sentenciaStore.setString("Par_TramFechaNacim",Utileria.convierteFecha(serviFunFoliosBean.getTramFechaNacim()));
								sentenciaStore.setInt("Par_TramParentesco",Utileria.convierteEntero(serviFunFoliosBean.getTramParentesco()));
								sentenciaStore.setString("Par_NoCertificadoDefun",serviFunFoliosBean.getNoCertificadoDefun());
								sentenciaStore.setDate("Par_FechaCertiDefun",OperacionesFechas.conversionStrDate(serviFunFoliosBean.getFechaCertiDefun()));

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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error Modifica ServiFunFolios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean autorizaRechazaSERVIFUN(final ServiFunFoliosBean serviFunFoliosBean) {
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
								String query = "call SERVIFUNFOLIOSPRO(?,?,?,?,?,	?,?,?,?,?," +
																	  "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServiFunFolioID",Utileria.convierteEntero(serviFunFoliosBean.getServiFunFolioID()));
								sentenciaStore.setString("Par_Proceso",serviFunFoliosBean.getProceso());
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(serviFunFoliosBean.getUsuarioAutoriza()));
								sentenciaStore.setInt("Par_UsuarioRechaza",Utileria.convierteEntero(serviFunFoliosBean.getUsuarioRechaza()));
								sentenciaStore.setString("Par_MotivoRechazo",serviFunFoliosBean.getMotivoRechazo());

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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error proceso Autoriza ServiFunFolios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// Consulta principal Servicios Funerarios
	public ServiFunFoliosBean consultaPrincipal(ServiFunFoliosBean serviFunFoliosBean, int tipoConsulta){
		String query = "call SERVIFUNFOLIOSCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(serviFunFoliosBean.getServiFunFolioID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNFOLIOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ServiFunFoliosBean serviFunFolios = new ServiFunFoliosBean();

				serviFunFolios.setServiFunFolioID(resultSet.getString("ServiFunFolioID"));
				serviFunFolios.setClienteID(resultSet.getString("ClienteID"));
				serviFunFolios.setTipoServicio(resultSet.getString("TipoServicio"));
				serviFunFolios.setFechaRegistro(resultSet.getString("FechaRegistro"));
				serviFunFolios.setEstatus(resultSet.getString("Estatus"));

				serviFunFolios.setDifunClienteID(resultSet.getString("DifunClienteID"));
				serviFunFolios.setDifunPrimerNombre(resultSet.getString("DifunPrimerNombre"));
				serviFunFolios.setDifunSegundoNombre(resultSet.getString("DifunSegundoNombre"));
				serviFunFolios.setDifunTercerNombre(resultSet.getString("DifunTercerNombre"));
				serviFunFolios.setDifunApePaterno(resultSet.getString("DifunApePaterno"));

				serviFunFolios.setDifunApeMaterno(resultSet.getString("DifunApeMaterno"));
				serviFunFolios.setDifunFechaNacim(resultSet.getString("DifunFechaNacim"));
				serviFunFolios.setDifunParentesco(resultSet.getString("DifunParentesco"));
				serviFunFolios.setTramClienteID(resultSet.getString("TramClienteID"));
				serviFunFolios.setTramPrimerNombre(resultSet.getString("TramPrimerNombre"));

				serviFunFolios.setTramSegundoNombre(resultSet.getString("TramSegundoNombre"));
				serviFunFolios.setTramTercerNombre(resultSet.getString("TramTercerNombre"));
				serviFunFolios.setTramApePaterno(resultSet.getString("TramApePaterno"));
				serviFunFolios.setTramApeMaterno(resultSet.getString("TramApeMaterno"));
				serviFunFolios.setTramFechaNacim(resultSet.getString("TramFechaNacim"));

				serviFunFolios.setTramParentesco(resultSet.getString("TramParentesco"));
				serviFunFolios.setNoCertificadoDefun(resultSet.getString("NoCertificadoDefun"));
				serviFunFolios.setFechaCertiDefun(resultSet.getString("FechaCertifDefun"));
				serviFunFolios.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
				serviFunFolios.setFechaAutoriza(resultSet.getString("FechaAutoriza"));

				serviFunFolios.setUsuarioRechaza(resultSet.getString("UsuarioRechaza"));
				serviFunFolios.setFechaRechazo(resultSet.getString("FechaRechazo"));
				serviFunFolios.setMotivoRechazo(resultSet.getString("MotivoRechazo"));
				serviFunFolios.setMontoApoyo(resultSet.getString("MontoApoyo"));
				serviFunFolios.setDifNombreCompleto(resultSet.getString("DifunNombreComp"));


			return serviFunFolios;
			}
		});
		return matches.size() > 0 ? (ServiFunFoliosBean) matches.get(0) : null;
	}

	// validacion para ventanilla  pago servifun
	public String consultaEstatusServifun(ServiFunFoliosBean serviFunFoliosBean, int tipoConsulta) {
		String estatusSolicitud = "";

		try{
			String query = "call SERVIFUNFOLIOSCON(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	serviFunFoliosBean.getServiFunFolioID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ServifunFoliosDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNFOLIOSCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String estatusSol = new String();

					estatusSol=resultSet.getString("Estatus");
						return estatusSol;
				}
			});
		estatusSolicitud= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus Servifun", e);
		}
		return estatusSolicitud;
	}


	// Lista principal
	public List listaPrincipal(ServiFunFoliosBean serviFunFolios, int tipoLista) {
		List listaServiFun = null ;
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"nombre: "+ serviFunFolios.getTramPrimerNombre());
		try{
			// Query con el Store Procedure
			String query = "call SERVIFUNFOLIOSLIS(?,?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(serviFunFolios.getServiFunFolioID()),
					serviFunFolios.getTramPrimerNombre(),
					Utileria.convierteEntero(serviFunFolios.getClienteID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNFOLIOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ServiFunFoliosBean serviFunFolios = new ServiFunFoliosBean();
					serviFunFolios.setServiFunFolioID(resultSet.getString("ServiFunFolioID"));
					serviFunFolios.setTramPrimerNombre(resultSet.getString("NombreCompleto"));
					serviFunFolios.setEstatusDescripcion(resultSet.getString("EstatusDescripcion"));

					return serviFunFolios;

				}
			});

			listaServiFun= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista principal de ServiFun", e);
		}
		return listaServiFun;
	}

	//------------------------------ Metodos de los beneficiarios --------------------------

	public List listaBeneficiarios(ServiFunFoliosBean serviFunFolios, int tipoLista) {
		List listaServiFun = null ;
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"nombre: "+ serviFunFolios.getTramPrimerNombre());
		try{
			// Query con el Store Procedure
			String query = "call SERVIFUNBENLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(serviFunFolios.getServiFunFolioID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"listaBeneficiarios",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNBENLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ServiFunFoliosBean serviFunFolios = new ServiFunFoliosBean();


					return serviFunFolios;

				}
			});

			listaServiFun= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de beneficiarios de ServiFun", e);
		}
		return listaServiFun;
	}

	public List listaReporteServifunExcel(final ServifunFoliosRepBean servifunFoliosRepBean, int tipoLista){
		List ListaResultado=null;

		try{
		String query = "call SERVIFUNFOLIOSREP(?,?,?,?,?,  ?,?,?,?,?, ?)";

		Object[] parametros ={
							Utileria.convierteFecha(servifunFoliosRepBean.getFechaInicio()),
							Utileria.convierteFecha(servifunFoliosRepBean.getFechaFin()),
							Utileria.convierteEntero(servifunFoliosRepBean.getSucursalID()),
							servifunFoliosRepBean.getEstatus(),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNFOLIOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ServifunFoliosRepBean servifunFoliosRep= new ServifunFoliosRepBean();

				servifunFoliosRep.setClienteID(resultSet.getString("ClienteID"));
				servifunFoliosRep.setNombreCompleto(resultSet.getString("NombreCompleto"));
				servifunFoliosRep.setServiFunFolioID(resultSet.getString("ServiFunFolioID"));
				servifunFoliosRep.setEstatus(resultSet.getString("Estatus"));

				servifunFoliosRep.setFechaRegistro(resultSet.getString("FechaRegistro"));
				servifunFoliosRep.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
				servifunFoliosRep.setTipoServicio(resultSet.getString("TipoServicio"));
				servifunFoliosRep.setDifunNombreComp(resultSet.getString("DifunNombreComp"));
				servifunFoliosRep.setNoCertificadoDefun(resultSet.getString("NoCertificadoDefun"));


				servifunFoliosRep.setFechaCertifDefun(resultSet.getString("FechaCertifDefun"));
				servifunFoliosRep.setMontoApoyo(resultSet.getString("MontoApoyo"));
				servifunFoliosRep.setFechaEntrega(resultSet.getString("FechaEntrega"));
				servifunFoliosRep.setHoraEmision(resultSet.getString("HoraEmision"));
				servifunFoliosRep.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
				servifunFoliosRep.setNombreSucurs(resultSet.getString("NombreSucurs"));

				servifunFoliosRep.setDesTipServicio(resultSet.getString("DesTipServicio"));
				servifunFoliosRep.setDesEstatus(resultSet.getString("DesEstatus"));



				return servifunFoliosRep;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reportes de Excel Servifun", e);
		}
		return ListaResultado;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
