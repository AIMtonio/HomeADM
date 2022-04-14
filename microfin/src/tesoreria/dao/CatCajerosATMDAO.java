	package tesoreria.dao;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.CatCajerosATMBean;
import tesoreria.bean.CatTipoCajeroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class CatCajerosATMDAO  extends BaseDAO{

	public CatCajerosATMDAO(){
		super();
	}

	public MensajeTransaccionBean altaCajeroATM(final CatCajerosATMBean catCajerosATMBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATCAJEROSATMALT(?,?,?,?,?, ?,?,?,?,?,"
																	+"?,?,?,?,?, ?,?,?,?,?,"
																	+"?,?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CajeroID",catCajerosATMBean.getCajeroID());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(catCajerosATMBean.getSucursalID()));
								sentenciaStore.setString("Par_NumCajeroProsa",catCajerosATMBean.getNumCajeroPROSA());
								sentenciaStore.setString("Par_Ubicacion",catCajerosATMBean.getUbicacion());
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(catCajerosATMBean.getUsuarioID()));

								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(catCajerosATMBean.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(catCajerosATMBean.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(catCajerosATMBean.getLocalidadID()));
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(catCajerosATMBean.getColoniaID()));
								sentenciaStore.setString("Par_Calle",catCajerosATMBean.getCalle());

								sentenciaStore.setString("Par_Numero",catCajerosATMBean.getNumero());
								sentenciaStore.setString("Par_NumInterior",catCajerosATMBean.getNumInterior());
								sentenciaStore.setString("Par_CtaContableMN",catCajerosATMBean.getCtaContableMN());
								sentenciaStore.setString("Par_CtaContableME",catCajerosATMBean.getCtaContableME());
								sentenciaStore.setString("Par_CtaContaMNTrans",catCajerosATMBean.getCtaContaMNTrans());

								sentenciaStore.setString("Par_CtaContaMETrans",catCajerosATMBean.getCtaContaMETrans());
								sentenciaStore.setString("Par_NomenclaturaCR", catCajerosATMBean.getNomenclaturaCR());
								sentenciaStore.setString("Par_Latitud", catCajerosATMBean.getLatitud());
								sentenciaStore.setString("Par_Longitud", catCajerosATMBean.getLongitud());
								sentenciaStore.setString("Par_CP", catCajerosATMBean.getCp());
								sentenciaStore.setString("Par_TipoCajeroID", catCajerosATMBean.getTipoCajeroID());

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta del Cajero", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaCajeroATM(final CatCajerosATMBean catCajerosATMBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATCAJEROSATMMOD(?,?,?,?,?,	?,?,?,?,?,"
																   + "?,?,?,?,?,	?,?,?,?,?,"
																   + "?,?,?,?,?,	?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CajeroID",catCajerosATMBean.getCajeroID());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(catCajerosATMBean.getSucursalID()));
								sentenciaStore.setString("Par_NumCajeroProsa",catCajerosATMBean.getNumCajeroPROSA());
								sentenciaStore.setString("Par_Ubicacion",catCajerosATMBean.getUbicacion());
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(catCajerosATMBean.getUsuarioID()));

								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(catCajerosATMBean.getEstadoID()));
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(catCajerosATMBean.getMunicipioID()));
								sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(catCajerosATMBean.getLocalidadID()));
								sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(catCajerosATMBean.getColoniaID()));
								sentenciaStore.setString("Par_Calle",catCajerosATMBean.getCalle());

								sentenciaStore.setString("Par_Numero",catCajerosATMBean.getNumero());
								sentenciaStore.setString("Par_NumInterior",catCajerosATMBean.getNumInterior());
								sentenciaStore.setString("Par_CtaContableMN",catCajerosATMBean.getCtaContableMN());
								sentenciaStore.setString("Par_CtaContableME",catCajerosATMBean.getCtaContableME());
								sentenciaStore.setString("Par_CtaContaMNTrans",catCajerosATMBean.getCtaContaMNTrans());

								sentenciaStore.setString("Par_CtaContaMETrans",catCajerosATMBean.getCtaContaMETrans());
								sentenciaStore.setString("Par_NomenclaturaCR", catCajerosATMBean.getNomenclaturaCR());
								sentenciaStore.setString("Par_Latitud", catCajerosATMBean.getLatitud());
								sentenciaStore.setString("Par_Longitud", catCajerosATMBean.getLongitud());
								sentenciaStore.setString("Par_CP", catCajerosATMBean.getCp());
								sentenciaStore.setString("Par_TipoCajeroID", catCajerosATMBean.getTipoCajeroID());

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificacion del cajero", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean cancelarCajeroATM(final CatCajerosATMBean catCajerosATMBean,final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CATCAJEROSATMACT(?,?,?,?,?, ?,?,?,?,?," +
																	"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CajeroID",catCajerosATMBean.getCajeroID());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								/*
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(catCajerosATMBean.getSucursalID()));
								sentenciaStore.setString("Par_Ubicacion",catCajerosATMBean.getUbicacion());
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(catCajerosATMBean.getUsuarioID()));


								sentenciaStore.setString("Par_CtaContableMN",catCajerosATMBean.getCtaContableMN());
								sentenciaStore.setString("Par_CtaContableME",catCajerosATMBean.getCtaContableME());
								sentenciaStore.setString("Par_CtaContaMNTrans",catCajerosATMBean.getCtaContaMNTrans());
								sentenciaStore.setString("Par_CtaContaMETrans",catCajerosATMBean.getCtaContaMETrans());
								*/

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)));
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la cancelacion del cajero ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// lista principal de Cajeros
		public List listaCajerosATM(int tipoLista, CatCajerosATMBean catCajerosATMBean) {
			List listaCajeros = null;
			try{
				String query = "call CATCAJEROSATMLIS(?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
									catCajerosATMBean.getCajeroID(),
									catCajerosATMBean.getNombreCompleto(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajerosATM",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCAJEROSATMLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CatCajerosATMBean catCajerosATM = new CatCajerosATMBean();
						catCajerosATM.setCajeroID(resultSet.getString("CajeroID"));
						catCajerosATM.setNombreCompleto(resultSet.getString("NombreCompleto"));
						catCajerosATM.setNombreSucursal(resultSet.getString("NombreSucurs"));

						return catCajerosATM;
					}
				});
					listaCajeros = matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Principal de  Cajeros ATM", e);
			}
			return listaCajeros;
		}

		// lista principal de Cajeros
		public List listaForaneaATM(int tipoLista, CatCajerosATMBean catCajerosATMBean) {
			List listaCajeros = null;
			try{
				String query = "call CATCAJEROSATMLIS(?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
									catCajerosATMBean.getCajeroID(),
									catCajerosATMBean.getNombreCompleto(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajerosATM",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCAJEROSATMLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CatCajerosATMBean catCajerosATM = new CatCajerosATMBean();
						catCajerosATM.setCajeroID(resultSet.getString(1));
						catCajerosATM.setNombreCompleto(resultSet.getString(2));
						catCajerosATM.setNombreSucursal(resultSet.getString(3));
						catCajerosATM.setUbicacion(resultSet.getString(4));

						return catCajerosATM;
					}
				});
					listaCajeros = matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Principal de  Cajeros ATM", e);
			}
			return listaCajeros;
		}

		// consulta  principal de Cajeros ATM
		public CatCajerosATMBean consultaPrincipal(CatCajerosATMBean catCajerosATMBean, int tipoConsulta) {
			CatCajerosATMBean cajeroATM = null;

			try{
				String query = "call CATCAJEROSATMCON(?,?,?,?,?, ?,?,?,?);";
				Object[] parametros = { catCajerosATMBean.getCajeroID(),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										OperacionesFechas.FEC_VACIA,
										Constantes.STRING_VACIO,
										"consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATCAJEROSATMCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						CatCajerosATMBean catCajerosATM = new CatCajerosATMBean();

						catCajerosATM.setCajeroID(resultSet.getString("CajeroID"));
						catCajerosATM.setSucursalID(resultSet.getString("SucursalID"));
						catCajerosATM.setNumCajeroPROSA(resultSet.getString("NumCajeroPROSA"));
						catCajerosATM.setUbicacion(resultSet.getString("Ubicacion"));
						catCajerosATM.setUsuarioID(resultSet.getString("UsuarioID"));

						catCajerosATM.setSaldoMN(resultSet.getString("SaldoMN"));
						catCajerosATM.setSaldoME(resultSet.getString("SaldoME"));
						catCajerosATM.setCtaContableMN(resultSet.getString("CtaContableMN"));
						catCajerosATM.setCtaContableME(resultSet.getString("CtaContableME"));
						catCajerosATM.setCtaContaMNTrans(resultSet.getString("CtaContaMNTrans"));

						catCajerosATM.setCtaContaMETrans(resultSet.getString("CtaContaMETrans"));
						catCajerosATM.setEstatus(resultSet.getString("Estatus"));
						catCajerosATM.setEstadoID(resultSet.getString("EstadoID"));
						catCajerosATM.setMunicipioID(resultSet.getString("MunicipioID"));
						catCajerosATM.setLocalidadID(resultSet.getString("LocalidadID"));

						catCajerosATM.setColoniaID(resultSet.getString("ColoniaID"));
						catCajerosATM.setCalle(resultSet.getString("Calle"));
						catCajerosATM.setNumero(resultSet.getString("Numero"));
						catCajerosATM.setNumInterior(resultSet.getString("NumInterior"));
						catCajerosATM.setNomenclaturaCR(resultSet.getString("NomenclaturaCR"));
						catCajerosATM.setLatitud(resultSet.getString("Latitud"));
						catCajerosATM.setLongitud(resultSet.getString("Longitud"));
						catCajerosATM.setCp(resultSet.getString("CP"));
						catCajerosATM.setTipoCajeroID(resultSet.getString("TipoCajeroID"));
						return catCajerosATM;
					}
				});
				cajeroATM= matches.size() > 0 ? (CatCajerosATMBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal de Cajeros ATM", e);
			}
			return cajeroATM;
		}


		/*
		 * Lista de Tipos de Cajero para el combo
		 */
		public List listaTipoCajerosATM(int tipoLista, CatTipoCajeroBean catTipoCajerosATMBean) {
			List listaCajeros = null;
			try{
				String query = "call CATTIPOCAJEROLIS(?,?,?,?,?, ?,?,?,?);";
				Object[] parametros = {
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajerosATM",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOCAJEROLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CatTipoCajeroBean catTipoCajerosATM = new CatTipoCajeroBean();
						catTipoCajerosATM.setTipoCajeroID(resultSet.getString("TipoCajeroID"));
						catTipoCajerosATM.setDescripcion(resultSet.getString("Descripcion"));

						return catTipoCajerosATM;
					}
				});
					listaCajeros = matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Principal de  Cajeros ATM", e);
			}
			return listaCajeros;
		}
}
