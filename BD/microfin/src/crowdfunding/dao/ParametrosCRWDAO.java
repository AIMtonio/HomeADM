package crowdfunding.dao;

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

import crowdfunding.bean.ParametrosCRWBean;

public class ParametrosCRWDAO extends BaseDAO{

	public ParametrosCRWDAO() {
		super();
	}

	/**
	 * Alta de los parámetros de Crowdfunding.
	 * @param parametrosBean {@linkplain ParametrosCRWBean} con los valores de entrada al SP-PARAMETROSCRWALT.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean altaParametros(final ParametrosCRWBean parametrosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PARAMETROSCRWALT("
											+ "?,?,?,?,?,	?,?,?,?,?,	"
											+ "?,?,?,?,?,	?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(parametrosBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_FormReten",parametrosBean.getFormulaRetencion());
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(parametrosBean.getTasaISR()));
									sentenciaStore.setDouble("Par_PorcISRMora",Utileria.convierteDoble(parametrosBean.getPorcISRMoratorio()));
									sentenciaStore.setDouble("Par_PorcISRComi",Utileria.convierteDoble(parametrosBean.getPorcISRComision()));

									sentenciaStore.setDouble("Par_MinPorFonPr",Utileria.convierteDoble(parametrosBean.getMinPorcFonProp()));
									sentenciaStore.setDouble("Par_MaxPorPaCre",Utileria.convierteDoble(parametrosBean.getMaxPorcPagCre()));
									sentenciaStore.setInt("Par_MaxDiasAtra",Utileria.convierteEntero(parametrosBean.getMaxDiasAtraso()));
									sentenciaStore.setInt("Par_DiasGraPriV",Utileria.convierteEntero(parametrosBean.getDiasGraciaPrimVen()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
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
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Modificación de los parámetros de Crowdfunding.
	 * @param parametrosBean {@linkplain ParametrosCRWBean} con los valores de entrada al SP-PARAMETROSCRWMOD.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean modificaParametros(final ParametrosCRWBean parametrosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PARAMETROSCRWMOD("
											+ "?,?,?,?,?,	?,?,?,?,?,	"
											+ "?,?,?,?,?,	?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(parametrosBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_FormReten",parametrosBean.getFormulaRetencion());
									sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(parametrosBean.getTasaISR()));
									sentenciaStore.setDouble("Par_PorcISRMora",Utileria.convierteDoble(parametrosBean.getPorcISRMoratorio()));
									sentenciaStore.setDouble("Par_PorcISRComi",Utileria.convierteDoble(parametrosBean.getPorcISRComision()));

									sentenciaStore.setDouble("Par_MinPorFonPr",Utileria.convierteDoble(parametrosBean.getMinPorcFonProp()));
									sentenciaStore.setDouble("Par_MaxPorPaCre",Utileria.convierteDoble(parametrosBean.getMaxPorcPagCre()));
									sentenciaStore.setInt("Par_MaxDiasAtra",Utileria.convierteEntero(parametrosBean.getMaxDiasAtraso()));
									sentenciaStore.setInt("Par_DiasGraPriV",Utileria.convierteEntero(parametrosBean.getDiasGraciaPrimVen()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
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
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta principal de los parámetros de Crowdfunding.
	 * @param parametrosBean {@linkplain ParametrosCRWBean} con los valores de entrada al SP-PARAMETROSCRWCON
	 * @param tipoConsulta 1.- Consulta Principal.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public ParametrosCRWBean consultaPrincipal(ParametrosCRWBean parametrosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PARAMETROSCRWCON(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {
				parametrosBean.getProductoCreditoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PARAMETROSCRWCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosCRWBean parametrosBean = new ParametrosCRWBean();
				parametrosBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				parametrosBean.setFormulaRetencion(resultSet.getString("FormulaRetencion"));
				parametrosBean.setTasaISR(resultSet.getString("TasaISR"));
				parametrosBean.setPorcISRMoratorio(resultSet.getString("PorcISRMoratorio"));
				parametrosBean.setPorcISRComision(resultSet.getString("PorcISRComision"));
				parametrosBean.setMinPorcFonProp(resultSet.getString("MinPorcFonProp"));
				parametrosBean.setMaxPorcPagCre(resultSet.getString("MaxPorcPagCre"));
				parametrosBean.setMaxDiasAtraso(resultSet.getString("MaxDiasAtraso"));
				parametrosBean.setDiasGraciaPrimVen(resultSet.getString("DiasGraciaPrimVen"));
				return parametrosBean;
			}
		});
		return matches.size() > 0 ? (ParametrosCRWBean) matches.get(0) : null;
	}
}