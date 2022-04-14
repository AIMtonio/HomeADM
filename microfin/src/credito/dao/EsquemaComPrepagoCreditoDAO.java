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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.SolicitudCheckListBean;


import credito.bean.EsquemaComPrepagoCreditoBean;
import credito.bean.EsquemaComisionCreBean;
import credito.bean.ProductosCreditoBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class EsquemaComPrepagoCreditoDAO extends BaseDAO{
	ProductosCreditoDAO productosCreditoDAO;
	public EsquemaComPrepagoCreditoDAO(){
		super();
	}

	//ALTA DE ESQUEMAS DE PREPAGO
	public MensajeTransaccionBean alta(final EsquemaComPrepagoCreditoBean esquemaComPrepagoCreditoBean) {
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
								String query = "call ESQUEMACOMPRECREALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(esquemaComPrepagoCreditoBean.getProductoID()));
								sentenciaStore.setString("Par_PermiteLiqAntici",esquemaComPrepagoCreditoBean.getPermiteLiqAntici());
								sentenciaStore.setString("Par_CobraComLiqAntici",esquemaComPrepagoCreditoBean.getCobraComLiqAntici());
								sentenciaStore.setString("Par_TipComLiqAntici",esquemaComPrepagoCreditoBean.getTipComLiqAntici());
								sentenciaStore.setDouble("Par_ComisionLiqAntici",Utileria.convierteDoble(esquemaComPrepagoCreditoBean.getComisionLiqAntici()));
								sentenciaStore.setInt("Par_DiasGraciaLiqAntici",Utileria.convierteEntero(esquemaComPrepagoCreditoBean.getDiasGraciaLiqAntici()));
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

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EsquemaComPrepagoCreditoDAO.alta");
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
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de esquema de comision de credito", e);

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

	//MODIFICACION  DE ESQUEMAS DE PREPAGO
	public MensajeTransaccionBean modifica(final EsquemaComPrepagoCreditoBean esquemaComPrepagoCreditoBean) {
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
								String query = "call ESQUEMACOMPRECREMOD(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(esquemaComPrepagoCreditoBean.getProductoID()));
								sentenciaStore.setString("Par_PermiteLiqAntici",esquemaComPrepagoCreditoBean.getPermiteLiqAntici());
								sentenciaStore.setString("Par_CobraComLiqAntici",esquemaComPrepagoCreditoBean.getCobraComLiqAntici());
								sentenciaStore.setString("Par_TipComLiqAntici",esquemaComPrepagoCreditoBean.getTipComLiqAntici());
								sentenciaStore.setDouble("Par_ComisionLiqAntici",Utileria.convierteDoble(esquemaComPrepagoCreditoBean.getComisionLiqAntici()));
								sentenciaStore.setInt("Par_DiasGraciaLiqAntici",Utileria.convierteEntero(esquemaComPrepagoCreditoBean.getDiasGraciaLiqAntici()));
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

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EsquemaComPrepagoCreditoDAO.modifica");
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
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion de esquema de comision de credito", e);

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

	//consulta Principal
		public EsquemaComPrepagoCreditoBean consultaPrincipal(EsquemaComPrepagoCreditoBean esquemaComPrepagoCredito, int tipoConsulta) {

			EsquemaComPrepagoCreditoBean esquemaComPrepagoCreditoConsulta = new EsquemaComPrepagoCreditoBean();
			try{
				//Query con el Store Procedure
				String query = "call ESQUEMACOMPRECRECON(?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = { Utileria.convierteEntero(esquemaComPrepagoCredito.getProductoID()),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"EsquemaComPrepagoCreditoDAO.consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMACOMPRECRECON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						EsquemaComPrepagoCreditoBean esquemaComPrepagoCredito = new EsquemaComPrepagoCreditoBean();
						esquemaComPrepagoCredito.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
						esquemaComPrepagoCredito.setDescripcion(resultSet.getString("Descripcion"));
						esquemaComPrepagoCredito.setPermiteLiqAntici(resultSet.getString("PermiteLiqAntici"));
						esquemaComPrepagoCredito.setCobraComLiqAntici(resultSet.getString("CobraComLiqAntici"));
						esquemaComPrepagoCredito.setTipComLiqAntici(resultSet.getString("TipComLiqAntici"));
						esquemaComPrepagoCredito.setComisionLiqAntici(String.valueOf(resultSet.getDouble("ComisionLiqAntici")));
						esquemaComPrepagoCredito.setDiasGraciaLiqAntici(String.valueOf(resultSet.getInt("DiasGraciaLiqAntici")));
		            	return esquemaComPrepagoCredito;
					}
				});
				esquemaComPrepagoCreditoConsulta= matches.size() > 0 ? (EsquemaComPrepagoCreditoBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal", e);
			}
			return esquemaComPrepagoCreditoConsulta;
		}

	public ProductosCreditoDAO getProductosCreditoDAO() {
		return productosCreditoDAO;
	}

	public void setProductosCreditoDAO(ProductosCreditoDAO productosCreditoDAO) {
		this.productosCreditoDAO = productosCreditoDAO;
	}


}
