package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ApoyoEscolarSolBean;
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

import soporte.bean.ParamApoyoEscolarBean;

public class ParamApoyoEscolarDAO extends BaseDAO{

	public ParamApoyoEscolarDAO() {
		super();
	}


	/*=============================== METODOS ==================================*/
	/* da de alta un nuevo registro */
	public MensajeTransaccionBean alta(final ParamApoyoEscolarBean paramApoyoEscolarBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call PARAMAPOYOESCOLARALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_ApoyoEscCicloID", Utileria.convierteEntero(paramApoyoEscolarBean.getApoyoEscCicloID()));
						sentenciaStore.setString("Par_TipoCalculo",paramApoyoEscolarBean.getTipoCalculo());
						sentenciaStore.setDouble("Par_PromedioMinimo",Utileria.convierteDoble(paramApoyoEscolarBean.getPromedioMinimo()));
						sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(paramApoyoEscolarBean.getCantidad()));
						sentenciaStore.setInt("Par_MesesAhorroCons", Utileria.convierteEntero(paramApoyoEscolarBean.getMesesAhorroCons()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMAPOYOESCOLARALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parametros apoyo escolar", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});



		return mensaje;
	}

	public MensajeTransaccionBean baja(final ParamApoyoEscolarBean paramApoyoEscolarBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	//*//transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call PARAMAPOYOESCOLARBAJ(?,?,?,?,?, ?,?,?,?,?, ?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_ParamApoyoEscID", Utileria.convierteEntero(paramApoyoEscolarBean.getParamApoyoEscID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMAPOYOESCOLARBAJ(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de parametros apoyo escolar", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});



		return mensaje;
	}


	/* Consuta Principal (por ApoyoEscCicloID), obtiene losparametros de un nivel escolar*/
	public ParamApoyoEscolarBean consultaPrincipal(ParamApoyoEscolarBean paramApoyoEscolar,int tipoConsulta) {

			ParamApoyoEscolarBean paramApoyoEscBean= new ParamApoyoEscolarBean();

		try{

			/*Query con el Store Procedure */
			String query = "call PARAMAPOYOESCOLARCON(?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
								   Utileria.convierteEntero(paramApoyoEscolar.getApoyoEscCicloID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	par_empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMAPOYOESCOLARCON(" + Arrays.toString(parametros) + ")");


			/*E]ecuta el query y setea los valores al bean para obtener los datos de la consulta*/
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
						/*bena para setear los valores obtenidos de la ejecucion de la consulta */
						ParamApoyoEscolarBean paramApoyoEscBean= new ParamApoyoEscolarBean();

						paramApoyoEscBean.setParamApoyoEscID(resultSet.getString("ParamApoyoEscID"));
						paramApoyoEscBean.setApoyoEscCicloID(resultSet.getString("ApoyoEscCicloID"));
						paramApoyoEscBean.setTipoCalculo(resultSet.getString("TipoCalculo"));
						paramApoyoEscBean.setPromedioMinimo(resultSet.getString("PromedioMinimo"));
						paramApoyoEscBean.setCantidad(resultSet.getString("Cantidad"));
						paramApoyoEscBean.setMesesAhorroCons(resultSet.getString("MesesAhorroCons"));

								return paramApoyoEscBean;
						}// trows ecexeption
			});//lista



			paramApoyoEscBean= matches.size() > 0 ? (ParamApoyoEscolarBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal parametros de Apoyo Escolar", e);
		}


		/*Retorna un objeto cargado de datos */
		return paramApoyoEscBean;

	}//fin consultaPrincipal



	/* Lista apoyo escolar grid*/
	public List listaPrincipal(ParamApoyoEscolarBean paramApoyoEscolarBean, int tipoLista) {
		String query = "call PARAMAPOYOESCOLARLIS(?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
								tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMAPOYOESCOLARLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParamApoyoEscolarBean apoyoEscGrid = new ParamApoyoEscolarBean();

				String tipoCalculo = resultSet.getString("TipoCalculo");
				if(tipoCalculo.equals("MF")){
					tipoCalculo = "MONTO FIJO";
				}
				else if(tipoCalculo.equals("SM")){
					tipoCalculo = "N VECES SALARIO MÍNIMO";
				}

				apoyoEscGrid.setParamApoyoEscID(resultSet.getString("ParamApoyoEscID"));
				apoyoEscGrid.setApoyoEscCicloID(resultSet.getString("ApoyoEscCicloID"));
				apoyoEscGrid.setDescripcion(resultSet.getString("Descripcion"));
				apoyoEscGrid.setTipoCalculo(tipoCalculo);
				apoyoEscGrid.setPromedioMinimo(resultSet.getString("PromedioMinimo"));
				apoyoEscGrid.setCantidad(resultSet.getString("Cantidad"));
				apoyoEscGrid.setMesesAhorroCons(resultSet.getString("MesesAhorroCons"));
				return apoyoEscGrid;
			}
		});

		return matches;
	}

}//class
