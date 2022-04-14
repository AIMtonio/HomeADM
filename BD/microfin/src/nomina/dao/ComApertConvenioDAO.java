package nomina.dao;

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

import nomina.bean.ComApertConvenioBean;
import nomina.bean.EsqComAperNominaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


public class ComApertConvenioDAO  extends BaseDAO {


	public ComApertConvenioDAO (){
		super ();
	}

	/**
	 *
	 * @param comApertConvenioBean : Bean de Esquema de Comision Apertura por Convenio
	 * @param listaEsquemaConvenio : Lista de Esquema de Comision Convenio
	 * @return
	 */
	public MensajeTransaccionBean comApertConvenioGrabar(final ComApertConvenioBean comApertConvenioBean, final List listaEsquemasConvenio) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					ComApertConvenioBean comApertConvenio;
					mensajeBean = bajaComApertConvenio(comApertConvenioBean,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaEsquemasConvenio.size(); i++){
						comApertConvenio = (ComApertConvenioBean)listaEsquemasConvenio.get(i);
						mensajeBean = altaComApertConvenio(comApertConvenio,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Esquema de Comision Apertura Grabado Exitósamente.");
					mensajeBean.setNombreControl("esqComApertID");
					mensajeBean.setConsecutivoInt(comApertConvenioBean.getEsqComApertID());

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Grabar Esquema de Comisión Apertura.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param comApertConvenioBean : Bean de Esquema de Comision Apertura por Convenio
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean bajaComApertConvenio(final ComApertConvenioBean comApertConvenioBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMAPERTCONVENIOBAJ(?,  ?,?,?,?,?,   ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_EsqComApertID",Utileria.convierteEntero(comApertConvenioBean.getEsqComApertID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Baja de Esquema de Cobro Comisión Apertura Convenios.", e);
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

	/**
	 *
	 * @param comApertConvenioBean : Bean de Esquema de Comision Apertura por Convenio
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaComApertConvenio(final ComApertConvenioBean comApertConvenioBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMAPERTCONVENIOALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_EsqComApertID",Utileria.convierteEntero(comApertConvenioBean.getEsqComApertID()));
								sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(comApertConvenioBean.getConvenioNominaID()));
								sentenciaStore.setString("Par_FormCobroComAper",comApertConvenioBean.getFormCobroComAper());
								sentenciaStore.setString("Par_TipoComApert",comApertConvenioBean.getTipoComApert());
								sentenciaStore.setString("Par_PlazoID",comApertConvenioBean.getPlazoID());

								sentenciaStore.setDouble("Par_MontoMin",Utileria.convierteDoble(comApertConvenioBean.getMontoMin()));
								sentenciaStore.setDouble("Par_MontoMax",Utileria.convierteDoble(comApertConvenioBean.getMontoMax()));
								sentenciaStore.setDouble("Par_Valor",Utileria.convierteDoble(comApertConvenioBean.getValor()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Grabar Esquema de Comisión por Apertura.", e);
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

	/**
	 *
	 * @param comApertConvenioBean : Bean de Esquema de Comision Apertura por Convenio
	 * @param tipoLista
	 * @return
	 */
	public List listaEsquemaConvenios(ComApertConvenioBean comApertConvenioBean, int tipoLista){
		List listaGrid = null;
		try{

		String query = "call COMAPERTCONVENIOLIS(?,?,?,?,?,  ?,?,?,?,?,  ?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(comApertConvenioBean.getEsqComApertID()),
				tipoLista,
				Utileria.convierteEntero(comApertConvenioBean.getConvenioNominaID()),
				comApertConvenioBean.getPlazoID(),
				Utileria.convierteDoble(comApertConvenioBean.getValor()),
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ComApertConvenioDAO.listaEsquemaConvenios",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMAPERTCONVENIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ComApertConvenioBean resultadoBean = new ComApertConvenioBean();
				resultadoBean.setEsqComApertID(resultSet.getString("EsqConvComAperID"));
				resultadoBean.setEsqComApertID(resultSet.getString("EsqComApertID"));
				resultadoBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				resultadoBean.setFormCobroComAper(resultSet.getString("FormCobroComAper"));
				resultadoBean.setTipoComApert(resultSet.getString("TipoComApert"));
				resultadoBean.setPlazoID(resultSet.getString("PlazoID"));
				resultadoBean.setMontoMin(resultSet.getString("MontoMin"));
				resultadoBean.setMontoMax(resultSet.getString("MontoMax"));
				resultadoBean.setValor(resultSet.getString("Valor"));
				resultadoBean.setFila(resultSet.getString("Fila"));

				return resultadoBean;

				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Esquema de Comisión por Apertura.", e);

		}
		return listaGrid;
	}

	// CONSULTA PRINCIPAL
	public ComApertConvenioBean consulta(int tipoConsulta, ComApertConvenioBean comApertConvenioBean) {
		ComApertConvenioBean registro = null;
		try {
			String query = "CALL COMAPERTCONVENIOCON (?,?,?,?,?,	?,?,?,?,?,   ?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(comApertConvenioBean.getEsqComApertID()),
					Utileria.convierteEntero(comApertConvenioBean.getEsqConvComAperID()),
					Utileria.convierteEntero(comApertConvenioBean.getConvenioNominaID()),
					comApertConvenioBean.getPlazoID(),
					comApertConvenioBean.getMonto(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL COMAPERTCONVENIOCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ComApertConvenioBean resultado = new ComApertConvenioBean();
					resultado.setEsqComApertID(resultSet.getString("EsqComApertID"));
					resultado.setEsqConvComAperID(resultSet.getString("EsqConvComAperID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setFormCobroComAper(resultSet.getString("FormCobroComAper"));
					resultado.setTipoComApert(resultSet.getString("TipoComApert"));
					resultado.setPlazoID(resultSet.getString("PlazoID"));
					resultado.setMontoMin(resultSet.getString("MontoMin"));
					resultado.setMontoMax(resultSet.getString("MontoMax"));
					resultado.setValor(resultSet.getString("Valor"));
					return resultado;
				}
			});
			registro = matches.size() > 0 ? (ComApertConvenioBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de ESQUEMA DE Comisión por Apertura", e);
		}
		return registro;
	}
}
