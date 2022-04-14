package aportaciones.dao;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import aportaciones.bean.PlazosAportacionesBean;
import aportaciones.dao.TasasAportacionesDAO;

public class PlazosAportacionesDAO extends BaseDAO{

	private TasasAportacionesDAO tasasAportacionesDAO;


	public PlazosAportacionesDAO() {
		super();
	}

	public MensajeTransaccionBean grabaListaPlazosAportaciones(final PlazosAportacionesBean bean, final List listaDias ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					PlazosAportacionesBean plazosBean;

					aportaciones.bean.TasasAportacionesBean tasaAportaciones = new aportaciones.bean.TasasAportacionesBean();
					tasaAportaciones.setTasaAportacionID("0");
					tasaAportaciones.setTipoAportacionID(bean.getTipoAportacionID());
					int tipoBaja=2;
					mensajeBean = tasasAportacionesDAO.eliminaTasas(tasaAportaciones,tipoBaja);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = bajaPlazos(bean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(int i=0; i<listaDias.size(); i++){
						plazosBean = (PlazosAportacionesBean)listaDias.get(i);
						mensajeBean = altaPlazos(plazosBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada. No Olvide Actualizar las Tasas de Aportaciones.");
					mensajeBean.setNombreControl("tipoAportacionID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Grabar Plazos de Aportaciones", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//método para dar de alta el plazo de la aportación
	public MensajeTransaccionBean altaPlazos(final PlazosAportacionesBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLAZOSAPORTACIONESPRO(?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoAportacionID", bean.getTipoAportacionID());
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

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSAPORTACIONESPRO(" + sentenciaStore.toString() + ")");

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta de plazos de aportaciones.", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});

			return mensaje;
		}

	/*Metodo Para eliminar plazos de APORTACIONES*/
	public MensajeTransaccionBean bajaPlazos(final PlazosAportacionesBean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLAZOSAPORTACIONESBAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TipoAportacionID", bean.getTipoAportacionID());

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

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSAPORTACIONESBAJ(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de plazos de aportaciones.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	//consulta principal de plazos de aportaciones
	public PlazosAportacionesBean consultaPrincipal(PlazosAportacionesBean plazosAportacionesBean, int tipoConsulta){
		String query = "call PLAZOSAPORTACIONESCON(?,?,?,?,?,  ?,?,?,?,?,  ?);";
		Object[] parametros = { plazosAportacionesBean.getTipoAportacionID(),
								plazosAportacionesBean.getPlazoInferior(),
								plazosAportacionesBean.getPlazoSuperior(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AportacionDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				PlazosAportacionesBean plazosAportacionesBean = new PlazosAportacionesBean();

				plazosAportacionesBean.setTipoAportacionID(Utileria.convierteEntero(resultSet.getString(1)));
				plazosAportacionesBean.setPlazoInferior(Utileria.convierteEntero(resultSet.getString(2)));
				plazosAportacionesBean.setPlazoSuperior(Utileria.convierteEntero(resultSet.getString(3)));

				return plazosAportacionesBean;
			}
		});
		return matches.size() > 0 ? (PlazosAportacionesBean) matches.get(0) : null;
	}

	/*Metodo para devolver lista */
	public List listaGrid(PlazosAportacionesBean bean, int tipoLista){
		String query = "call PLAZOSAPORTACIONESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	bean.getTipoAportacionID(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"plazosAportacionesDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PlazosAportacionesBean plazosb = new PlazosAportacionesBean();
				plazosb.setPlazoInferior(resultSet.getInt(1));
				plazosb.setPlazoSuperior(resultSet.getInt(2));
				return plazosb;
			}
		});
		return matches;
	}

	// Método que lista los plazos definidos en la tabla PLAZOSAPORTACIONES. Esta lista se usa en la pantalla de Tasas de APORTACIONES y Reporte de Captación.
	public List listaComboBox(PlazosAportacionesBean beanLista, int tipoLista){
		String query = "call PLAZOSAPORTACIONESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	beanLista.getTipoAportacionID(),
								tipoLista,
								Constantes.ENTERO_CERO,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"plazosAportacionesDAO.listaComboBox",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZOSAPORTACIONESLIS(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PlazosAportacionesBean plazosb = new PlazosAportacionesBean();
				plazosb.setPlazoInferior(Utileria.convierteEntero(resultSet.getString("PlazoInferior")));
				plazosb.setPlazosDescripcion(resultSet.getString("PlazosDescripcion"));
				return plazosb;
			}
		});
		return matches;
	}

	public TasasAportacionesDAO getTasasAportacionesDAO() {
		return tasasAportacionesDAO;
	}

	public void setTasasAportacionesDAO(TasasAportacionesDAO tasasAportacionesDAO) {
		this.tasasAportacionesDAO = tasasAportacionesDAO;
	}



}
