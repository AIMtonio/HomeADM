package cedes.dao;

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

import cedes.bean.PlazosCedesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class PlazosCedesDAO extends BaseDAO{

	private TasasCedesDAO tasasCedesDAO;


	public PlazosCedesDAO() {
		super();
	}


	public MensajeTransaccionBean grabaListaPlazosCedes(final PlazosCedesBean bean, final List listaDias ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					PlazosCedesBean plazosBean;

					cedes.bean.TasasCedesBean tasaCedes = new cedes.bean.TasasCedesBean();
					tasaCedes.setTasaCedeID("0");
					tasaCedes.setTipoCedeID(bean.getTipoCedeID());
					int tipoBaja=2;
					mensajeBean = tasasCedesDAO.eliminaTasas(tasaCedes,tipoBaja);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = bajaPlazos(bean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(int i=0; i<listaDias.size(); i++){
						plazosBean = (PlazosCedesBean)listaDias.get(i);
						mensajeBean = altaPlazos(plazosBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada. No Olvide Actualizar las Tasas de CEDES.");
					mensajeBean.setNombreControl("tipoCedeID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Grabar Plazos de CEDES", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Metodo Para eliminar plazos de CEDES*/

	public MensajeTransaccionBean altaPlazos(final PlazosCedesBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLAZOSCEDESALT(?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TipoCedeID", bean.getTipoCedeID());
							sentenciaStore.setInt("Par_PlazosInferior", bean.getPlazoInferior());
							sentenciaStore.setInt("Par_PlazosSuperior", bean.getPlazoSuperior());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESALT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta de plazos de cedes.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}



/*	public MensajeTransaccionBean altaPlazos(PlazosCedesBean bean) {
		String query = "call PLAZOSCEDESALT(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				bean.getTipoCedeID(),
				bean.getPlazoInferior(),
				bean.getPlazoSuperior(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"MontosInversionDAO.alta",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESALT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}*/


	/*Metodo Para eliminar plazos de CEDES*/

	public MensajeTransaccionBean bajaPlazos(final PlazosCedesBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLAZOSCEDESBAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TipoCedeID", bean.getTipoCedeID());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESBAJ(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de plazos de cedes.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	/*
	public MensajeTransaccionBean bajaPlazos(PlazosCedesBean bean) {
		String query = "call PLAZOSCEDESBAJ(?,?,?,?,?, ?,?,?);";

		Object[] parametros = {
				bean.getTipoCedeID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"MontosInversionDAO.bajaMontosCedes",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}
	*/


	public PlazosCedesBean consultaPrincipal(PlazosCedesBean plazosCedesBean, int tipoConsulta){
		String query = "call PLAZOSCEDESCON(?,?,?,?,?,  ?,?,?,?,?,  ?);";
		Object[] parametros = { plazosCedesBean.getTipoCedeID(),
								plazosCedesBean.getPlazoInferior(),
								plazosCedesBean.getPlazoSuperior(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InversionDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				PlazosCedesBean plazosCedesBean = new PlazosCedesBean();

				plazosCedesBean.setTipoCedeID(Utileria.convierteEntero(resultSet.getString(1)));
				plazosCedesBean.setPlazoInferior(Utileria.convierteEntero(resultSet.getString(2)));
				plazosCedesBean.setPlazoSuperior(Utileria.convierteEntero(resultSet.getString(3)));

				return plazosCedesBean;
			}
		});
		return matches.size() > 0 ? (PlazosCedesBean) matches.get(0) : null;
	}


	/*Metodo para devolver lista */
	public List listaGrid(PlazosCedesBean bean, int tipoLista){
		String query = "call PLAZOSCEDESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	bean.getTipoCedeID(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"plazosCedesDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PlazosCedesBean plazosb = new PlazosCedesBean();
				plazosb.setPlazoInferior(resultSet.getInt(1));
				plazosb.setPlazoSuperior(resultSet.getInt(2));
				return plazosb;
			}
		});
		return matches;
	}

	/**
	 * Método que lista los plazos definidos en la tabla PLAZOSCEDES. Esta lista se usa en la pantalla de Tasas de CEDES y Reporte de Captación.
	 * @param beanLista : Clase bean con los valores para los parámetros de entrada al SP-PLAZOSCEDESLIS. (TipoCedeID).
	 * @param tipoLista : Número de lista: 3 para listar los plazos en el combo (select).
	 * @return List : Lista de los plazos por tipo de CEDE.
	 * @author avelasco
	 */
	public List listaComboBox(PlazosCedesBean beanLista, int tipoLista){
		String query = "call PLAZOSCEDESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	beanLista.getTipoCedeID(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"plazosCedesDAO.listaComboBox",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSCEDESLIS(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PlazosCedesBean plazosb = new PlazosCedesBean();
				plazosb.setPlazoInferior(Utileria.convierteEntero(resultSet.getString("PlazoInferior")));
				plazosb.setPlazosDescripcion(resultSet.getString("PlazosDescripcion"));
				return plazosb;
			}
		});
		return matches;
	}



	public void setTasasCedesDAO(TasasCedesDAO tasasCedesDAO) {
		this.tasasCedesDAO = tasasCedesDAO;
	}



}
