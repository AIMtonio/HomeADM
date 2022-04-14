package spei.dao;

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

import spei.bean.PagoRemesasTraspasosSpeiBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class PagoRemesasTraspasosSpeiDAO extends BaseDAO {

	public PagoRemesasTraspasosSpeiDAO() {
		super();
	}
	public MensajeTransaccionBean procesoRemesas(PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean, int tipoTransaccion, final List listaCodigosResp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean;
					  String consecutivo= mensajeBean.getConsecutivoString();
					  int tipoTransaccion=1;
						for(int i=0; i<listaCodigosResp.size(); i++){

							pagoRemesasTraspasosSpeiBean = (PagoRemesasTraspasosSpeiBean)listaCodigosResp.get(i);

							mensajeBean = pagoRemesaSpei(pagoRemesasTraspasosSpeiBean, tipoTransaccion);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Actualiza el estatus
	public MensajeTransaccionBean pagoRemesaSpei(final PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SPEITRANSFERENCIASPRO(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_SpeiTransID",Utileria.convierteEntero(pagoRemesasTraspasosSpeiBean.getSpeiTransID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(pagoRemesasTraspasosSpeiBean.getCuentaAho()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(pagoRemesasTraspasosSpeiBean.getClienteID()));
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteFlotante(pagoRemesasTraspasosSpeiBean.getMonto()));
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(pagoRemesasTraspasosSpeiBean.getUsuarioAutoriza()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
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

	//Consulta Remesas de Traspasos Spei
	public List listaPagoRemesas(PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean, int tipoConsulta) {
		List pagoRemesasTraspasosSpeiBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call SPEITRANSFERENCIASLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = { pagoRemesasTraspasosSpeiBean.getSpeiTransID(),
									pagoRemesasTraspasosSpeiBean.getEstatus(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEITRANSFERENCIASLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean = new PagoRemesasTraspasosSpeiBean();

					pagoRemesasTraspasosSpeiBean.setSpeiTransID(String.valueOf(resultSet.getString("SpeiTransID")));
					pagoRemesasTraspasosSpeiBean.setClabeCli(String.valueOf(resultSet.getString("ClabeCli")));
					pagoRemesasTraspasosSpeiBean.setNombreCli(resultSet.getString("NombreCli"));
					pagoRemesasTraspasosSpeiBean.setMonto(String.valueOf(resultSet.getString("Monto")));
					pagoRemesasTraspasosSpeiBean.setCuentaAho(String.valueOf(resultSet.getString("CuentaAhoID")));
					pagoRemesasTraspasosSpeiBean.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
					pagoRemesasTraspasosSpeiBean.setBanco(String.valueOf(resultSet.getString("Banco")));
					pagoRemesasTraspasosSpeiBean.setSucursal(String.valueOf(resultSet.getString("NombreSucurs")));
					pagoRemesasTraspasosSpeiBean.setNombreRemesedora(String.valueOf(resultSet.getString("NombreRem")));
					pagoRemesasTraspasosSpeiBean.setRazonSocialRemesedora(String.valueOf(resultSet.getString("RazonSocialRem")));
					pagoRemesasTraspasosSpeiBean.setClienteIDRemesedora(String.valueOf(resultSet.getString("clienteIDRem")));
					pagoRemesasTraspasosSpeiBean.setTipoCuentaRemesedora(String.valueOf(resultSet.getString("TipoCuentaRem")));
					pagoRemesasTraspasosSpeiBean.setCuentaRemesedora(String.valueOf(resultSet.getString("CuentaRem")));

					return pagoRemesasTraspasosSpeiBean;
				}
			});
			pagoRemesasTraspasosSpeiBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Pagos de Remesas de Traspasos Spei", e);

		}
		return pagoRemesasTraspasosSpeiBeanCon;
	}




}
