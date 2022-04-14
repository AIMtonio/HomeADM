package ventanilla.dao;

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
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.ProspectosBean;
import ventanilla.bean.UsuarioServiciosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class UsuarioServiciosDAO extends BaseDAO{

	public UsuarioServiciosDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/* Alta Usuario*/
	public MensajeTransaccionBean altaUsuario(final UsuarioServiciosBean usuario) {
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

								usuario.setTelefonoCelular(usuario.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								usuario.setTelefonoCasa(usuario.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "call USUARIOSERVICIOALT( ?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
												  				  		"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
												  				  		"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

							    sentenciaStore.setString("Par_TipoPersona",usuario.getTipoPersona());
				           		sentenciaStore.setString("Par_PrimerNombre",usuario.getPrimerNombre());
				           		sentenciaStore.setString("Par_SegundoNombre",usuario.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNombre",usuario.getTercerNombre());
								sentenciaStore.setString("Par_ApPaterno",usuario.getApellidoPaterno());

								sentenciaStore.setString("Par_ApMaterno",usuario.getApellidoMaterno());
								sentenciaStore.setString("Par_FechaNac", (usuario.getFechaNacimiento() == null || usuario.getFechaNacimiento()=="") ? Constantes.FECHA_VACIA:usuario.getFechaNacimiento());
								sentenciaStore.setString("Par_Nacion",usuario.getNacion());
								sentenciaStore.setInt("Par_PaisNac",Utileria.convierteEntero(usuario.getPaisNacimiento()));
								sentenciaStore.setInt("Par_EstadoNac",Utileria.convierteEntero(usuario.getEstadoNac()));

								sentenciaStore.setString("Par_Sexo",usuario.getSexo());
								sentenciaStore.setString("Par_CURP",usuario.getCURP());
								sentenciaStore.setString("Par_RazonSocial",usuario.getRazonSocial());
								sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(usuario.getTipoSociedadID()));
								sentenciaStore.setString("Par_RFC",usuario.getRFC());

								sentenciaStore.setString("Par_RFCpm",usuario.getRFCpm());
								sentenciaStore.setString("Par_FEA",usuario.getFEA());
								sentenciaStore.setString("Par_FechaCons", (usuario.getFechaConstitucion() == null || usuario.getFechaConstitucion()=="") ? Constantes.FECHA_VACIA:usuario.getFechaConstitucion());
								sentenciaStore.setInt("Par_PaisRFC",Utileria.convierteEntero(usuario.getPaisRFC()));
								sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(usuario.getOcupacionID()));

								sentenciaStore.setString("Par_Correo",usuario.getCorreo());
								sentenciaStore.setString("Par_TelefonoCel",usuario.getTelefonoCelular());
								sentenciaStore.setString("Par_Telefono",usuario.getTelefonoCasa());
								sentenciaStore.setString("Par_ExtTelefono",usuario.getExtTelefonoPart());
								sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(usuario.getSucursalOrigen()));

								sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(usuario.getPaisResidencia()));
								sentenciaStore.setInt("Par_TipoDirecID",Utileria.convierteEntero(usuario.getTipoDireccionID()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(usuario.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(usuario.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(usuario.getLocalidadID()));

								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(usuario.getColoniaID()));
								sentenciaStore.setString("Par_Calle",usuario.getCalle());
								sentenciaStore.setString("Par_NumeroCasa",usuario.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",usuario.getNumInterior());
								sentenciaStore.setString("Par_CP",usuario.getCP());

								sentenciaStore.setString("Par_Piso",usuario.getPiso());
								sentenciaStore.setString("Par_Manzana",usuario.getManzana());
								sentenciaStore.setString("Par_Lote",usuario.getLote());
								sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(usuario.getTipoIdentiID()));
								sentenciaStore.setString("Par_NumIdenti",usuario.getNumIdentific());

								sentenciaStore.setString("Par_FecExIden", (usuario.getFecExIden() == null || usuario.getFecExIden()=="") ? Constantes.FECHA_VACIA:usuario.getFecExIden());
								sentenciaStore.setString("Par_FecVenIden", (usuario.getFecVenIden() == null || usuario.getFecVenIden()=="") ? Constantes.FECHA_VACIA:usuario.getFecVenIden());
								sentenciaStore.setString("Par_DocEstLegal",usuario.getLote());
								sentenciaStore.setString("Par_DocExisLegal",usuario.getLote());
								sentenciaStore.setString("Par_FechaVenEst", (usuario.getFechaVenEst() == null || usuario.getFechaVenEst()=="") ? Constantes.FECHA_VACIA:usuario.getFechaVenEst());

								sentenciaStore.setString("Par_NivelRiesgo",usuario.getNivelRiesgo());

								sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_UsuarioID", Types.INTEGER);

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
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));
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
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del usuario de servicios: " + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del usuario de servicios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de Usuario*/
	public MensajeTransaccionBean modificaUsuario(final UsuarioServiciosBean usuario) {
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

								usuario.setTelefonoCelular(usuario.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								usuario.setTelefonoCasa(usuario.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

								String query = "call USUARIOSERVICIOMOD( ?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
												  				  		"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
												  				  		"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

							    sentenciaStore.setString("Par_UsuarioID",usuario.getUsuarioID());
							    sentenciaStore.setString("Par_TipoPersona",usuario.getTipoPersona());
				           		sentenciaStore.setString("Par_PrimerNombre",usuario.getPrimerNombre());
				           		sentenciaStore.setString("Par_SegundoNombre",usuario.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNombre",usuario.getTercerNombre());

								sentenciaStore.setString("Par_ApPaterno",usuario.getApellidoPaterno());
								sentenciaStore.setString("Par_ApMaterno",usuario.getApellidoMaterno());
								sentenciaStore.setString("Par_FechaNac", (usuario.getFechaNacimiento() == null || usuario.getFechaNacimiento()=="") ? Constantes.FECHA_VACIA:usuario.getFechaNacimiento());
								sentenciaStore.setString("Par_Nacion",usuario.getNacion());
								sentenciaStore.setInt("Par_PaisNac",Utileria.convierteEntero(usuario.getPaisNacimiento()));

								sentenciaStore.setInt("Par_EstadoNac",Utileria.convierteEntero(usuario.getEstadoNac()));
								sentenciaStore.setString("Par_Sexo",usuario.getSexo());
								sentenciaStore.setString("Par_CURP",usuario.getCURP());
								sentenciaStore.setString("Par_RazonSocial",usuario.getRazonSocial());
								sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(usuario.getTipoSociedadID()));

								sentenciaStore.setString("Par_RFC",usuario.getRFC());
								sentenciaStore.setString("Par_RFCpm",usuario.getRFCpm());
								sentenciaStore.setString("Par_FEA",usuario.getFEA());
								sentenciaStore.setString("Par_FechaCons", (usuario.getFechaConstitucion() == null || usuario.getFechaConstitucion()=="") ? Constantes.FECHA_VACIA:usuario.getFechaConstitucion());
								sentenciaStore.setInt("Par_PaisRFC",Utileria.convierteEntero(usuario.getPaisRFC()));

								sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(usuario.getOcupacionID()));
								sentenciaStore.setString("Par_Correo",usuario.getCorreo());
								sentenciaStore.setString("Par_TelefonoCel",usuario.getTelefonoCelular());
								sentenciaStore.setString("Par_Telefono",usuario.getTelefonoCasa());
								sentenciaStore.setString("Par_ExtTelefono",usuario.getExtTelefonoPart());

								sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(usuario.getSucursalOrigen()));
								sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(usuario.getPaisResidencia()));
								sentenciaStore.setInt("Par_TipoDirecID",Utileria.convierteEntero(usuario.getTipoDireccionID()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(usuario.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(usuario.getMunicipioID()));

								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(usuario.getLocalidadID()));
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(usuario.getColoniaID()));
								sentenciaStore.setString("Par_Calle",usuario.getCalle());
								sentenciaStore.setString("Par_NumeroCasa",usuario.getNumExterior());
								sentenciaStore.setString("Par_NumInterior",usuario.getNumInterior());

								sentenciaStore.setString("Par_CP",usuario.getCP());
								sentenciaStore.setString("Par_Piso",usuario.getPiso());
								sentenciaStore.setString("Par_Manzana",usuario.getManzana());
								sentenciaStore.setString("Par_Lote",usuario.getLote());
								sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(usuario.getTipoIdentiID()));

								sentenciaStore.setString("Par_NumIdenti",usuario.getNumIdentific());
								sentenciaStore.setString("Par_FecExIden", (usuario.getFecExIden() == null || usuario.getFecExIden()=="") ? Constantes.FECHA_VACIA:usuario.getFecExIden());
								sentenciaStore.setString("Par_FecVenIden", (usuario.getFecVenIden() == null || usuario.getFecVenIden()=="") ? Constantes.FECHA_VACIA:usuario.getFecVenIden());
								sentenciaStore.setString("Par_DocEstLegal",usuario.getLote());
								sentenciaStore.setString("Par_DocExisLegal",usuario.getLote());

								sentenciaStore.setString("Par_FechaVenEst", (usuario.getFechaVenEst() == null || usuario.getFechaVenEst()=="") ? Constantes.FECHA_VACIA:usuario.getFechaVenEst());
								sentenciaStore.setString("Par_NivelRiesgo",usuario.getNivelRiesgo());

								sentenciaStore.setString("Par_Salida",salidaPantalla);
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));
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
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del usuario de servicios: " + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del usuario de servicios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Inactivación de Usuario
	public MensajeTransaccionBean inactivaUsuario(final UsuarioServiciosBean usuarioServiciosBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call USUARIOSERVICIOACT(?,?,?,?,"
																	 	 + "?,?,?,"
																	 	 + "?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_UsuarioServicioID", Utileria.convierteEntero(usuarioServiciosBean.getUsuarioID()));
									sentenciaStore.setInt("Par_UsuarioUnificadoID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_NivelRiesgo",usuarioServiciosBean.getNivelRiesgo());
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("usuarioID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Inactivación del Usuario de Servicio.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Consuta Usuario*/
	public UsuarioServiciosBean consultaPrincipal(UsuarioServiciosBean usuarioServicios, int tipoConsulta) {
		UsuarioServiciosBean usuarioServiciosBean = null;
		try{
			//Query con el Store Procedure
			String query = "call USUARIOSERVICIOCON(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(usuarioServicios.getUsuarioID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioServiciosDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERVICIOCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						UsuarioServiciosBean usuario = new UsuarioServiciosBean();

						usuario.setUsuarioID(resultSet.getString("UsuarioServicioID"));
						usuario.setTipoPersona(resultSet.getString("TipoPersona"));
						usuario.setPrimerNombre(resultSet.getString("PrimerNombre"));
						usuario.setSegundoNombre(resultSet.getString("SegundoNombre"));
						usuario.setTercerNombre(resultSet.getString("TercerNombre"));

						usuario.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
						usuario.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
						usuario.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
						usuario.setNacion(resultSet.getString("Nacionalidad"));
						usuario.setPaisNacimiento(resultSet.getString("PaisNacimiento"));

						usuario.setEstadoNac(resultSet.getString("EstadoNacimiento"));
						usuario.setSexo(resultSet.getString("Sexo"));
						usuario.setCURP(resultSet.getString("CURP"));
						usuario.setRazonSocial(resultSet.getString("RazonSocial"));
						usuario.setTipoSociedadID(resultSet.getString("TipoSociedadID"));

						usuario.setRFC(resultSet.getString("RFC"));
						usuario.setRFCpm(resultSet.getString("RFCpm"));
						//usuario.setRFC(resultSet.getString("RFCOficial"));
						usuario.setFEA(resultSet.getString("FEA"));
						usuario.setFechaConstitucion(resultSet.getString("FechaConstitucion"));
						usuario.setPaisRFC(resultSet.getString("PaisRFC"));

						usuario.setOcupacionID(resultSet.getString("OcupacionID"));
						usuario.setCorreo(resultSet.getString("Correo"));
						usuario.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
						usuario.setTelefonoCasa(resultSet.getString("Telefono"));
						usuario.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));

						usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
						usuario.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
						usuario.setPaisResidencia(resultSet.getString("PaisResidencia"));
						usuario.setTipoDireccionID(resultSet.getString("TipoDireccionID"));
						usuario.setEstadoID(resultSet.getString("EstadoID"));

						usuario.setMunicipioID(resultSet.getString("MunicipioID"));
						usuario.setLocalidadID(resultSet.getString("LocalidadID"));
						usuario.setColoniaID(resultSet.getString("ColoniaID"));
						usuario.setCalle(resultSet.getString("Calle"));
						usuario.setNumExterior(resultSet.getString("NumExterior"));

						usuario.setNumInterior(resultSet.getString("NumInterior"));
						usuario.setCP(resultSet.getString("CP"));
						usuario.setPiso(resultSet.getString("Piso"));
						usuario.setManzana(resultSet.getString("Manzana"));
						usuario.setLote(resultSet.getString("Lote"));

						usuario.setDireccion(resultSet.getString("DirCompleta"));
						usuario.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
						usuario.setNumIdentific(resultSet.getString("NumIdenti"));
						usuario.setFecExIden(resultSet.getString("FecExIden"));
						usuario.setFecVenIden(resultSet.getString("FecVenIden"));

						usuario.setDocEstanciaLegal(resultSet.getString("DocEstanciaLegal"));
						usuario.setDocExisLegal(resultSet.getString("DocExisLegal"));
						usuario.setFechaVenEst(resultSet.getString("FechaVenEst"));
						usuario.setUsuarioUnificadoID(resultSet.getString("UsuarioUnificadoID"));
						usuario.setNivelRiesgo(resultSet.getString("NivelRiesgo"));

						usuario.setEstatus(resultSet.getString("Estatus"));

						return usuario;
				}
			});
			usuarioServiciosBean= matches.size() > 0 ? (UsuarioServiciosBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de usuarios de servicio", e);

		}
		return usuarioServiciosBean;
		}

	// Consulta de Remitentes del Usuario de Servicio
	public UsuarioServiciosBean consultaRemitentesUsuario(UsuarioServiciosBean usuarioServicios, int tipoConsulta) {
		UsuarioServiciosBean usuarioServiciosBean = null;
		try{
			//Query con el Store Procedure
			String query = "call REMITENTESUSUARIOSERVCON(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(usuarioServicios.getUsuarioID()),
									Utileria.convierteLong(usuarioServicios.getRemitenteID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioServiciosDAO.consultaRemitentesUsuario",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMITENTESUSUARIOSERVCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						UsuarioServiciosBean usuario = new UsuarioServiciosBean();

						usuario.setUsuarioID(resultSet.getString("UsuarioServicioID"));
						usuario.setFechaRem(resultSet.getString("Fecha"));
						usuario.setRemitenteID(resultSet.getString("RemitenteID"));
						usuario.setTituloRem(resultSet.getString("Titulo"));
						usuario.setTipoPersonaRem(resultSet.getString("TipoPersona"));

						usuario.setNombreCompletoRem(resultSet.getString("NombreCompleto"));
						usuario.setFechaNacimientoRem(resultSet.getString("FechaNacimiento"));
						usuario.setPaisNacimientoRem(resultSet.getString("PaisNacimiento"));
						usuario.setEstadoNacRem(resultSet.getString("EdoNacimiento"));
						usuario.setEstadoCivilRem(resultSet.getString("EstadoCivil"));

						usuario.setSexoRem(resultSet.getString("Sexo"));
						usuario.setCURPRem(resultSet.getString("CURP"));
						usuario.setRFCRem(resultSet.getString("RFC"));
						usuario.setFEARem(resultSet.getString("FEA"));
						usuario.setPaisFEARem(resultSet.getString("PaisFEA"));

						usuario.setOcupacionRem(resultSet.getString("OcupacionID"));
						usuario.setPuestoRem(resultSet.getString("Puesto"));
						usuario.setSectorGeneralRem(resultSet.getString("SectorID"));
						usuario.setActividadBancoMXRem(resultSet.getString("ActividadBMXID"));
						usuario.setActividadINEGIRem(resultSet.getString("ActividadINEGIID"));

						usuario.setSectorEconomicoRem(resultSet.getString("SectorEcoID"));
						usuario.setTipoIdentiIDRem(resultSet.getString("TipoIdentiID"));
						usuario.setNumIdentificRem(resultSet.getString("NumIdentific"));
						usuario.setFecExIdenRem(resultSet.getString("FecExIden"));
						usuario.setFecVenIdenRem(resultSet.getString("FecVenIden"));

						usuario.setTelefonoCasaRem(resultSet.getString("TelefonoCasa"));
						usuario.setExtTelefonoPartRem(resultSet.getString("ExtTelefonoPart"));
						usuario.setTelefonoCelularRem(resultSet.getString("TelefonoCelular"));
						usuario.setCorreoRem(resultSet.getString("Correo"));
						usuario.setDomicilioRem(resultSet.getString("Domicilio"));

						usuario.setNacionRem(resultSet.getString("Nacionalidad"));
						usuario.setPaisResidenciaRem(resultSet.getString("PaisResidencia"));

						return usuario;
				}
			});
			usuarioServiciosBean= matches.size() > 0 ? (UsuarioServiciosBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Remitentes de Usuario de Servicios.", e);

		}
		return usuarioServiciosBean;
	}

	public List listaPrincipal(UsuarioServiciosBean usuarioServicios, int tipoLista){
		String query = "call USUARIOSERVICIOLIS(?,?,?,?,?,	?,?,?,?);";

		Object[] parametros = {
					usuarioServicios.getNombreCompleto(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERVICIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioServiciosBean usuarioServicios = new UsuarioServiciosBean();
				usuarioServicios.setUsuarioID(resultSet.getString("UsuarioServicioID"));
				usuarioServicios.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuarioServicios;
			}
		});
		return matches;
	}

	public List listaVentanilla(UsuarioServiciosBean usuarioServicios, int tipoLista){
		String query = "call USUARIOSERVICIOLIS(?,?,?,?,?,	?,?,?,?);";

		Object[] parametros = {
					usuarioServicios.getNombreCompleto(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERVICIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioServiciosBean usuarioServicios = new UsuarioServiciosBean();
				usuarioServicios.setUsuarioID(resultSet.getString("UsuarioServicioID"));
				usuarioServicios.setNombreCompleto(resultSet.getString("NombreCompleto"));
				usuarioServicios.setDireccion(resultSet.getString("Direccion"));
				usuarioServicios.setNombreSucursal(resultSet.getString("NombreSucurs"));
				return usuarioServicios;
			}
		});
		return matches;
	}

	// Lista de Remitentes de Usuario de Servicio
	public List listaRemitentesUsuario(UsuarioServiciosBean usuarioServicios, int tipoLista){
		String query = "call REMITENTESUSUARIOSERVLIS(?,?,?,?,?,	?,?,?,?,?, ?);";

		Object[] parametros = {
					Utileria.convierteEntero(usuarioServicios.getUsuarioID()),
					Constantes.ENTERO_CERO,
					usuarioServicios.getNombreCompleto(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMITENTESUSUARIOSERVLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioServiciosBean usuarioServicios = new UsuarioServiciosBean();
				usuarioServicios.setRemitenteID(resultSet.getString("RemitenteID"));
				usuarioServicios.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuarioServicios;
			}
		});
		return matches;
	}

	/* metodo de lista para obtener los datos para el reporte de usuarios de servicio*/
	  public List listaReporte(UsuarioServiciosBean usuarioServicios, int tipoReporte){
			List ListaResultado=null;

			try{
			String query = "CALL USUARIOSERVICIOREP(?,?,?,?,?,  ?,?,?,?,?, ?)";
			Object[] parametros ={

								usuarioServicios.getUsuarioID(),
								usuarioServicios.getSucursalID(),
								usuarioServicios.getSexo(),
								tipoReporte,

					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};




			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL USUARIOSERVICIOREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioServiciosBean usuarioSerBean = new UsuarioServiciosBean();

					usuarioSerBean.setUsuarioID(resultSet.getString("UsuarioServicioID"));
					usuarioSerBean.setTipoPersona(resultSet.getString("TipoPersona"));
					usuarioSerBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					usuarioSerBean.setFechaNacimiento(resultSet.getString("FechaNac"));
					usuarioSerBean.setNacion(resultSet.getString("Nacion"));


					usuarioSerBean.setPaisResidencia(resultSet.getString("PaisRes"));
					usuarioSerBean.setEstadoNac(resultSet.getString("EstadoNac"));

					usuarioSerBean.setDireccion(resultSet.getString("DirCompleta"));
					usuarioSerBean.setSexo(resultSet.getString("Sexo"));
					usuarioSerBean.setCURP(resultSet.getString("CURP"));

					usuarioSerBean.setRFC(resultSet.getString("RFC"));
					usuarioSerBean.setOcupacionID(resultSet.getString("Ocupacion"));
					usuarioSerBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
					usuarioSerBean.setFechaConstitucion(resultSet.getString("FechaConstitucion"));

					return usuarioSerBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Usuarios Servicios", e);
			}
			return ListaResultado;
		}// fin lista report

	// Lista de Tipo de Persona ComboBox
	public List listaTipoPersona(int tipoLista){
		String query = "call CATTIPOSPERSONALIS(?,?,?,?,?,	?,?,?);";

		Object[] parametros = {	tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioServiciosDAO.listaTipoPersona",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOSPERSONALIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				UsuarioServiciosBean usuarioSerBean = new UsuarioServiciosBean();
				usuarioSerBean.setTipoPersona(resultSet.getString("TipoPersona"));
				usuarioSerBean.setDescripcion(resultSet.getString("Descripcion"));
				return usuarioSerBean;
			}
		});
		return matches;

	}

	/**
	* Método para recorrer y mandar a unificar los usuarios de servicios
	* @param UsuarioServiciosBean : Bean con la informacion de los usuarios de servicios
	* @param tipoActualizacion : Número de actualización 2. unificación de usuario de servicios
	* @return {@link MensajeTransaccionBean}
	*/
	public MensajeTransaccionBean unificaUsuarios(final UsuarioServiciosBean usuario, int tipoActualizacion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		int usuarioServiciosID = 0;

		try {
			transaccionDAO.generaNumeroTransaccion();
			int usuarioUnificadoID = Utileria.convierteEntero(usuario.getUsuarioID());
			String usuariosServiciosID[] = usuario.getUsuariosID().split(",");

			for (String usuarioID : usuariosServiciosID) {

				usuarioServiciosID = Utileria.convierteEntero(usuarioID);
				mensaje = unificaUsuario(usuarioServiciosID, usuarioUnificadoID, tipoActualizacion);

				if (mensaje.getNumero() != 0) {
					throw new Exception(mensaje.getDescripcion());
				}
			}
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(ex.getMessage());

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en unificación de usuarios de servicios.", ex);
		}
		return mensaje;
	}

	/**
	* Método que realiza la unificación del usuario de servicios
	* @param UsuarioServiciosBean : Bean con la informacion del usuario de servicios
	* @param tipoActualizacion : Número de actualización 2. unificación de usuario de servicios
	* @return {@link MensajeTransaccionBean}
	*/
	public MensajeTransaccionBean unificaUsuario(final int usuarioServicioID, final int usuarioUnificadoID, final int tipoActualizacion) {
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

								String query = "call USUARIOSERVICIOACT(?,?,?,?,"
																	 + "?,?,?,"
																	 + "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_UsuarioServicioID", usuarioServicioID);
								sentenciaStore.setInt("Par_UsuarioUnificadoID", usuarioUnificadoID);
								sentenciaStore.setString("Par_NivelRiesgo", Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no regresó ningun resultado.");
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la unificación del usuario de servicios: " + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la unificación del usuario de servicios: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	* Método para consultar usuario que tenga coincidencias con otros usuarios que se le puedan unificar.
	* @param usuarioID : Identificador del usuario a consultar.
	* @param tipoConsulta : Número de consulta 5. Consulta de usuario con coincidencias.
	* @return {@link UsuarioServiciosBean}.
	*/
	public UsuarioServiciosBean consultaUnificacion(UsuarioServiciosBean usuarioBean, int tipoConsulta) {

		UsuarioServiciosBean usuarioServiciosBean = null;

		try {
			String query = "call USUARIOSERVICIOCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(usuarioBean.getUsuarioID()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"UsuarioServiciosDAO.consultaUnificacion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERVICIOCON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					UsuarioServiciosBean usuario = new UsuarioServiciosBean();

					usuario.setUsuarioID(resultSet.getString("UsuarioServicioID"));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
					usuario.setRFC(resultSet.getString("RFC"));
					usuario.setCURP(resultSet.getString("CURP"));
					usuario.setSexo(resultSet.getString("Sexo"));
					usuario.setFechaNacimiento(resultSet.getString("FechaNacimiento"));

					return usuario;
				}
			});

			usuarioServiciosBean = matches.size() > 0 ? (UsuarioServiciosBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la consulta de usuarios de servicio: ", e);
		}

		return usuarioServiciosBean;
	}

	/**
	* Método para listar los usuarios de servicios que tengan coincidencia con el usuario consultado.
	* @param usuarioServicios : Datos del usuario consultado
	* @param tipoLista : Número de lista 4. todas las coincidencias con el usuario consultado.
	* @return {@link List}.
	*/
	public List listaCoincidencias(UsuarioServiciosBean usuarioServicios, int tipoLista) {

		List listaCoincidencias = null;
		try {
			String query = "call COINCIDEREMESASUSUSERLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
								usuarioServicios.getUsuarioID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.listaCoincidencias",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COINCIDEREMESASUSUSERLIS(  " + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
				throws SQLException {
					UsuarioServiciosBean usuarioBean = new UsuarioServiciosBean();
					usuarioBean.setUsuarioID(resultSet.getString("UsuarioServCoinID"));
					usuarioBean.setNombreCompleto(resultSet.getString("NombreCompletoCoin"));
					usuarioBean.setRFC(resultSet.getString("RFCCoin"));
					usuarioBean.setCURP(resultSet.getString("CURPCoin"));
					usuarioBean.setCoincidencia(resultSet.getString("PorcConcidencia"));

					return usuarioBean;
				}
			});
			listaCoincidencias  = matches;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de coincidencias de usuarios de servicios", e);
		}
		return listaCoincidencias;
	}

	/* Alta de Remitente de Usuario de servicio*/
	public MensajeTransaccionBean altaRemitenteUsuario(final UsuarioServiciosBean usuario) {
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

									usuario.setTelefonoCelularRem(usuario.getTelefonoCelularRem().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									usuario.setTelefonoCasaRem(usuario.getTelefonoCasaRem().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

									String query = "call REMITENTESUSUARIOSERVALT( ?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
													  				  		"?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

								    sentenciaStore.setInt("Par_UsuarioServicioID",Utileria.convierteEntero(usuario.getUsuarioID()));
					           		sentenciaStore.setString("Par_Titulo",usuario.getTituloRem());
					           		sentenciaStore.setString("Par_TipoPersona",usuario.getTipoPersonaRem());
									sentenciaStore.setString("Par_NombreCompleto",usuario.getNombreCompletoRem());
									sentenciaStore.setString("Par_FechaNacimiento",(usuario.getFechaNacimientoRem() == null || usuario.getFechaNacimientoRem()=="") ? Constantes.FECHA_VACIA:usuario.getFechaNacimientoRem());

									sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(usuario.getPaisNacimientoRem()));
									sentenciaStore.setInt("Par_EdoNacimiento", Utileria.convierteEntero(usuario.getEstadoNacRem()));
									sentenciaStore.setString("Par_EstadoCivil",usuario.getEstadoCivilRem());
									sentenciaStore.setString("Par_Sexo",usuario.getSexoRem());
									sentenciaStore.setString("Par_CURP",usuario.getCURPRem());

									sentenciaStore.setString("Par_RFC",usuario.getRFCRem());
									sentenciaStore.setString("Par_FEA",usuario.getFEARem());
									sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(usuario.getPaisFEARem()));
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(usuario.getOcupacionRem()));
									sentenciaStore.setString("Par_Puesto",usuario.getPuestoRem());

									sentenciaStore.setInt("Par_SectorID", Utileria.convierteEntero(usuario.getSectorGeneralRem()));
									sentenciaStore.setString("Par_ActividadBMXID",usuario.getActividadBancoMXRem());
									sentenciaStore.setInt("Par_ActividadINEGIID", Utileria.convierteEntero(usuario.getActividadINEGIRem()));
									sentenciaStore.setInt("Par_SectorEcoID",Utileria.convierteEntero(usuario.getSectorEconomicoRem()));
									sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(usuario.getTipoIdentiIDRem()));

									sentenciaStore.setString("Par_NumIdentific",usuario.getNumIdentificRem());
									sentenciaStore.setString("Par_FecExIden",(usuario.getFecExIdenRem() == null ||usuario.getFecExIdenRem()=="") ? Constantes.FECHA_VACIA:usuario.getFecExIdenRem());
									sentenciaStore.setString("Par_FecVenIden",(usuario.getFecVenIdenRem() == null ||usuario.getFecVenIdenRem()=="") ? Constantes.FECHA_VACIA:usuario.getFecVenIdenRem());
									sentenciaStore.setString("Par_TelefonoCasa",usuario.getTelefonoCasaRem());
									sentenciaStore.setString("Par_ExtTelefonoPart",usuario.getExtTelefonoPartRem());

									sentenciaStore.setString("Par_TelefonoCelular",usuario.getTelefonoCelularRem());
									sentenciaStore.setString("Par_Correo",usuario.getCorreoRem());
									sentenciaStore.setString("Par_Domicilio",usuario.getDomicilioRem());
									sentenciaStore.setString("Par_Nacionalidad",usuario.getNacionRem());
									sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(usuario.getPaisResidenciaRem()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
								if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de remitente de usuario de servicios: " + mensajeBean.getDescripcion());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del usuario de servicios: ", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
	  /* Modificacion del Remitente de Usuario*/
	  public MensajeTransaccionBean modificaRemitenteUsuario(final UsuarioServiciosBean usuario) {
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

									usuario.setTelefonoCelularRem(usuario.getTelefonoCelularRem().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									usuario.setTelefonoCasaRem(usuario.getTelefonoCasaRem().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

									String query = "call REMITENTESUSUARIOSERVMOD( ?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?," +
													  				  		"?,?,?,?,?,	?,?,?,?,?,	?," +
													  				  		"?,?,?,	?,?,?,?,?,	?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_UsuarioServicioID",Utileria.convierteEntero(usuario.getUsuarioID()));
									sentenciaStore.setInt("Par_RemitenteID",Utileria.convierteEntero(usuario.getRemitenteID()));
					           		sentenciaStore.setString("Par_Titulo",usuario.getTituloRem());
					           		sentenciaStore.setString("Par_TipoPersona",usuario.getTipoPersonaRem());
									sentenciaStore.setString("Par_NombreCompleto",usuario.getNombreCompletoRem());

									sentenciaStore.setString("Par_FechaNacimiento",(usuario.getFechaNacimientoRem() == null || usuario.getFechaNacimientoRem()=="") ? Constantes.FECHA_VACIA:usuario.getFechaNacimientoRem());
									sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(usuario.getPaisNacimientoRem()));
									sentenciaStore.setInt("Par_EdoNacimiento", Utileria.convierteEntero(usuario.getEstadoNacRem()));
									sentenciaStore.setString("Par_EstadoCivil",usuario.getEstadoCivilRem());
									sentenciaStore.setString("Par_Sexo",usuario.getSexoRem());

									sentenciaStore.setString("Par_CURP",usuario.getCURPRem());
									sentenciaStore.setString("Par_RFC",usuario.getRFCRem());
									sentenciaStore.setString("Par_FEA",usuario.getFEARem());
									sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(usuario.getPaisFEARem()));
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(usuario.getOcupacionRem()));

									sentenciaStore.setString("Par_Puesto",usuario.getPuestoRem());
									sentenciaStore.setInt("Par_SectorID",Utileria.convierteEntero(usuario.getSectorGeneralRem()));
									sentenciaStore.setString("Par_ActividadBMXID",usuario.getActividadBancoMXRem());
									sentenciaStore.setInt("Par_ActividadINEGIID", Utileria.convierteEntero(usuario.getActividadINEGIRem()));
									sentenciaStore.setInt("Par_SectorEcoID",Utileria.convierteEntero(usuario.getSectorEconomicoRem()));

									sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(usuario.getTipoIdentiIDRem()));
									sentenciaStore.setString("Par_NumIdentific",usuario.getNumIdentificRem());
									sentenciaStore.setString("Par_FecExIden",(usuario.getFecExIdenRem() == null ||usuario.getFecExIdenRem()=="") ? Constantes.FECHA_VACIA:usuario.getFecExIdenRem());
									sentenciaStore.setString("Par_FecVenIden",(usuario.getFecVenIdenRem() == null ||usuario.getFecVenIdenRem()=="") ? Constantes.FECHA_VACIA:usuario.getFecVenIdenRem());
									sentenciaStore.setString("Par_TelefonoCasa",usuario.getTelefonoCasaRem());

									sentenciaStore.setString("Par_ExtTelefonoPart",usuario.getExtTelefonoPartRem());
									sentenciaStore.setString("Par_TelefonoCelular",usuario.getTelefonoCelularRem());
									sentenciaStore.setString("Par_Correo",usuario.getCorreoRem());
									sentenciaStore.setString("Par_Domicilio",usuario.getDomicilioRem());
									sentenciaStore.setString("Par_Nacionalidad",usuario.getNacionRem());

									sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(usuario.getPaisResidenciaRem()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
								if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del remitente de usuario de servicios: " + mensajeBean.getDescripcion());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del remitente de usuario de servicios: ", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/**
	* Método de consulta a usuario para poder dar de alta o modificar conocimiento del usuario de servicios.
	* @param usuarioID : Identificador del usuario a consultar.
	* @param tipoConsulta : Número de consulta 6. Consulta de usuario para dar de alta o modificar conocimientos.
	* @return {@link UsuarioServiciosBean}.
	*/
	public UsuarioServiciosBean consultaConocimiento(UsuarioServiciosBean usuarioBean, int tipoConsulta) {

		UsuarioServiciosBean usuarioServiciosBean = null;

		try {
			String query = "call USUARIOSERVICIOCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(usuarioBean.getUsuarioID()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"UsuarioServiciosDAO.consultaUnificacion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSERVICIOCON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					UsuarioServiciosBean usuario = new UsuarioServiciosBean();

					usuario.setUsuarioID(resultSet.getString("UsuarioServicioID"));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
					usuario.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
					usuario.setNacion(resultSet.getString("Nacionalidad"));

					return usuario;
				}
			});

			usuarioServiciosBean = matches.size() > 0 ? (UsuarioServiciosBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la consulta de usuarios de servicio: ", e);
		}

		return usuarioServiciosBean;
	}
}
