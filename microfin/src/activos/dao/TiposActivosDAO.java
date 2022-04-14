package activos.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import activos.bean.ClasifTiposActivosBean;
import activos.bean.TiposActivosBean;

public class TiposActivosDAO extends BaseDAO{
	private final static String salidaPantalla = "S";

	public TiposActivosDAO(){
		super();
	}

	/* ALTA DE TIPO DE ACTIVO */
	public MensajeTransaccionBean altaTipoActivo(final TiposActivosBean tiposActivosBean) {
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

								String query = "call TIPOSACTIVOSALT(?,?,?,?,?, ?,"
																   +"?,?,?, ?,?,?,?,?,?,?);"; // parametros salida y auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_Descripcion",tiposActivosBean.getDescripcion());
								sentenciaStore.setString("Par_DescripcionCorta",tiposActivosBean.getDescripcionCorta());
								sentenciaStore.setDouble("Par_DepreciacionAnual",Utileria.convierteDoble(tiposActivosBean.getDepreciacionAnual()));
								sentenciaStore.setInt("Par_ClasificaActivoID",Utileria.convierteEntero(tiposActivosBean.getClasificaActivoID()));
								sentenciaStore.setInt("Par_TiempoAmortiMeses",Utileria.convierteEntero(tiposActivosBean.getTiempoAmortiMeses()));

								sentenciaStore.setString("Par_Estatus",tiposActivosBean.getEstatus());

								//Parametros de Salida
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
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposActivosDAO.altaTipoActivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .TiposActivosDAO.altaTipoActivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de tipo de activo" + e);
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

	/* MODIFICACION DE TIPO DE ACTIVO */
	public MensajeTransaccionBean modificaTipoActivo(final TiposActivosBean tiposActivosBean) {
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

								String query = "call TIPOSACTIVOSMOD(?,?,?,?,?, ?,?,"
																   +"?,?,?, ?,?,?,?,?,?,?);"; // parametros salida y auditoria

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoActivoID",Utileria.convierteEntero(tiposActivosBean.getTipoActivoID()));
								sentenciaStore.setString("Par_Descripcion",tiposActivosBean.getDescripcion());
								sentenciaStore.setString("Par_DescripcionCorta",tiposActivosBean.getDescripcionCorta());
								sentenciaStore.setDouble("Par_DepreciacionAnual",Utileria.convierteDoble(tiposActivosBean.getDepreciacionAnual()));
								sentenciaStore.setInt("Par_ClasificaActivoID",Utileria.convierteEntero(tiposActivosBean.getClasificaActivoID()));

								sentenciaStore.setInt("Par_TiempoAmortiMeses",Utileria.convierteEntero(tiposActivosBean.getTiempoAmortiMeses()));
								sentenciaStore.setString("Par_Estatus",tiposActivosBean.getEstatus());

								//Parametros de Salida
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
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposActivosDAO.modificaTipoActivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .TiposActivosDAO.modificaTipoActivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de tipo de activo" + e);
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

	/* CONSULTA DE TIPO DE ACTIVOS */
	public TiposActivosBean consultaTiposActivos(int tipoConsulta, TiposActivosBean tiposActivosBean) {
		TiposActivosBean bean = null;
		try{
			// Query con el Store Procedure
			String query = "call TIPOSACTIVOSCON(?,?,"
											   +"?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(tiposActivosBean.getTipoActivoID()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TiposActivosDAO.consultaTiposActivos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSACTIVOSCON(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					TiposActivosBean beanConsulta = new TiposActivosBean();

					beanConsulta.setTipoActivoID(resultSet.getString("TipoActivoID"));
					beanConsulta.setDescripcion(resultSet.getString("Descripcion"));
					beanConsulta.setDescripcionCorta(resultSet.getString("DescripcionCorta"));
					beanConsulta.setDepreciacionAnual(resultSet.getString("DepreciacionAnual"));
					beanConsulta.setClasificaActivoID(resultSet.getString("ClasificaActivoID"));

					beanConsulta.setTiempoAmortiMeses(resultSet.getString("TiempoAmortiMeses"));
					beanConsulta.setEstatus(resultSet.getString("Estatus"));
					beanConsulta.setClaveTipoActivo(resultSet.getString("ClaveTipoActivo"));

					return beanConsulta;

				}
			});

			bean= matches.size() > 0 ? (TiposActivosBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos de tipos de activos", e);
		}
		return bean;
	}

	/* LISTA DE TIPOS DE ACTIVOS */
	public List listaTiposActivos(int tipoLista, TiposActivosBean tiposActivosBean) {
		// Query con el Store Procedure
		String query = "call TIPOSACTIVOSLIS(?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			tiposActivosBean.getDescripcion(),
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"TiposActivosDAO.listaTiposActivos",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				TiposActivosBean bean = new TiposActivosBean();

				bean.setTipoActivoID(resultSet.getString("TipoActivoID"));
				bean.setDescripcionCorta(resultSet.getString("DescripcionCorta"));
				bean.setEstatus(resultSet.getString("Estatus"));

				return bean;
			}
		});

		return matches;
	}

	/* LISTA CLASIFICACION DE TIPOS DE ACTIVOS */
	public List listaClasifTiposActivos(int tipoLista) {
		// Query con el Store Procedure
		String query = "call CLASIFICACTIVOSLIS(?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"TiposActivosDAO.listaClasifTiposActivos",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				ClasifTiposActivosBean bean = new ClasifTiposActivosBean();

				bean.setClasificaActivoID(resultSet.getString("ClasificaActivoID"));
				bean.setDescripcion(resultSet.getString("Descripcion"));

				return bean;
			}
		});

		return matches;
	}

	/* LISTA COMBO TIPOS DE ACTIVOS */
	public List listaComboTiposActivos(int tipoLista) {
		// Query con el Store Procedure
		String query = "call TIPOSACTIVOSLIS(?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			Constantes.STRING_VACIO,
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"TiposActivosDAO.listaComboTiposActivos",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				TiposActivosBean bean = new TiposActivosBean();

				bean.setTipoActivoID(resultSet.getString("TipoActivoID"));
				bean.setDescripcionCorta(resultSet.getString("DescripcionCorta"));

				return bean;
			}
		});

		return matches;
	}

}
