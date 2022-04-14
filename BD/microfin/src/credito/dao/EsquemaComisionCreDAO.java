package credito.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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

import credito.bean.EsquemaComisionCreBean;
import credito.bean.ProductosCreditoBean;

public class EsquemaComisionCreDAO extends BaseDAO{
	ProductosCreditoDAO productosCreditoDAO;
	public EsquemaComisionCreDAO(){
		super();
	}

	public MensajeTransaccionBean altaEsquemaComision(final EsquemaComisionCreBean esquemaComisionCreBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ESQUEMACOMISCREALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setDouble("Par_MontoInicial",Utileria.convierteDoble(esquemaComisionCreBean.getMontoInicial()));
								sentenciaStore.setDouble("Par_MontoFinal",Utileria.convierteDoble(esquemaComisionCreBean.getMontoFinal()));
								sentenciaStore.setString("Par_TipoComision",esquemaComisionCreBean.getTipoComision());
								sentenciaStore.setDouble("Par_Comision",Utileria.convierteDoble(esquemaComisionCreBean.getComision()));
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaComisionCreBean.getProducCreditoID()));

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

	public MensajeTransaccionBean bajaEsquemaComision(final EsquemaComisionCreBean esquemaComisionCreBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ESQUEMACOMISCREBAJ(?,?,?,?,?  ,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esquemaComisionCreBean.getProducCreditoID()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de esquema de comision de credito ", e);
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

	//Graba los Esquemas de Comision: Elimina ,Actuliza Productos de Credito y da de alta los Esquemas.
	public MensajeTransaccionBean grabaEsquemasComision(final EsquemaComisionCreBean esquemaComisionCreBean, int tipoTransaccion, final List listaCodigosResp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					EsquemaComisionCreBean esquemaComisionCreBean2;
					ProductosCreditoBean productosCreditoBean = new ProductosCreditoBean ();
					  String consecutivo= mensajeBean.getConsecutivoString();
					  int tipoTransaccion=1;

					  productosCreditoBean.setCriterioComFalPag(esquemaComisionCreBean.getCriterioComFalPag());
					  productosCreditoBean.setMontoMinComFalPag(esquemaComisionCreBean.getMontoMinComFalPag());
					  productosCreditoBean.setProducCreditoID(esquemaComisionCreBean.getProducCreditoID());

					  productosCreditoBean.setPerCobComFalPag(esquemaComisionCreBean.getPerCobComFalPag());
					  productosCreditoBean.setTipCobComFalPago(esquemaComisionCreBean.getTipCobComFalPago());
					  productosCreditoBean.setProrrateoComFalPag(esquemaComisionCreBean.getProrrateoComFalPag());
					  productosCreditoBean.setTipoPagoComFalPago(esquemaComisionCreBean.getTipoPagoComFalPago());


					String[] valuesArray = (productosCreditoBean.getProducCreditoID()).split(",\\s*");
					  for (String productoCredito : valuesArray) {
						  productosCreditoBean.setProducCreditoID(productoCredito);
						  esquemaComisionCreBean.setProducCreditoID(productoCredito);

						}

					  // funcion de baja

					  mensajeBean = bajaEsquemaComision(esquemaComisionCreBean);

					  if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
					  }
					  int actualizaComision = 1;
					  // funcion actualiza productos de credito
					  mensajeBean = productosCreditoDAO.actualizar(productosCreditoBean, actualizaComision);

					  // funcion alta esquema Comision Credito
					  if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
					  }
						for(int i=0; i<listaCodigosResp.size(); i++){
							esquemaComisionCreBean2 = (EsquemaComisionCreBean)listaCodigosResp.get(i);
							esquemaComisionCreBean2.setProducCreditoID( productosCreditoBean.getProducCreditoID());
							mensajeBean = altaEsquemaComision(esquemaComisionCreBean2, tipoTransaccion);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

				}

				catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en funcion de alta de esquema de comision de credito", e);
				if(mensajeBean.getNumero()==0){
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
// lista para llenar el grid
	public List lista(EsquemaComisionCreBean esquemaComisionCreBean, int tipoLista) {
		String query = "call ESQUEMACOMISCRELIS(?,?,?,?,?  ,?,?,?,?);";
		Object[] parametros = {
				esquemaComisionCreBean.getProducCreditoID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"DiasInversionDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMACOMISCRELIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaComisionCreBean esquemaComisionCreBean = new EsquemaComisionCreBean();
				esquemaComisionCreBean.setEsquemaComID(resultSet.getString(1));
				esquemaComisionCreBean.setMontoInicial(resultSet.getString(2));
				esquemaComisionCreBean.setMontoFinal(resultSet.getString(3));
				esquemaComisionCreBean.setTipoComision(resultSet.getString(4));
				esquemaComisionCreBean.setComision(resultSet.getString(5));

				return esquemaComisionCreBean;
			}
		});
		return matches;

	}

	public ProductosCreditoDAO getProductosCreditoDAO() {
		return productosCreditoDAO;
	}

	public void setProductosCreditoDAO(ProductosCreditoDAO productosCreditoDAO) {
		this.productosCreditoDAO = productosCreditoDAO;
	}


}
