package cobranza.dao;

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

import cobranza.bean.BitacoraSegCobBean;
import cobranza.bean.RepBitacoraSegCobBean;

public class BitacoraSegCobDAO extends BaseDAO{

	public BitacoraSegCobDAO(){
		super();
	}

	//Metodo de alta de bitacora de seguimiento de cobranza
	public MensajeTransaccionBean grabaBitacoraSegCob(final BitacoraSegCobBean bitacoraSegCobBean, final List listaPromesas ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					BitacoraSegCobBean bitSegCobBean;
						//alta del regisro en la bitacora
						mensajeBean = altaBitacoraSegCob(bitacoraSegCobBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						String bitSegCobID = mensajeBean.getConsecutivoString();
						if(listaPromesas.size()>0){
							for(int i=0; i < listaPromesas.size(); i++){
								bitSegCobBean = new BitacoraSegCobBean();
								bitSegCobBean = (BitacoraSegCobBean) listaPromesas.get(i);
								bitSegCobBean.setBitSegCobID(bitSegCobID);

								//alta de las promesas de pago
								mensajeBean= altaPromesa(bitSegCobBean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							mensajeBean.setConsecutivoString(bitacoraSegCobBean.getCreditoID());
							mensajeBean.setNombreControl("creditoID");
						 }else{
							mensajeBean.setDescripcion("Lista Promesas Vacia");
							throw new Exception(mensajeBean.getDescripcion());
						}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Alta de Bitacora de Seguimiento de Cobranza", e);
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

	//Alta bitacora se seguimiento de cobranza
	public MensajeTransaccionBean altaBitacoraSegCob(final BitacoraSegCobBean bitacoraSegCobBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call BITACORASEGCOBALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?," +
										"?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_FechaSis",Utileria.convierteFecha(bitacoraSegCobBean.getFechaSis()));
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(bitacoraSegCobBean.getUsuarioID()));
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(bitacoraSegCobBean.getSucursalID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(bitacoraSegCobBean.getCreditoID()));
								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(bitacoraSegCobBean.getClienteID()));

								sentenciaStore.setInt("Par_AccionID",Utileria.convierteEntero(bitacoraSegCobBean.getAccionID()));
								sentenciaStore.setInt("Par_RespuestaID",Utileria.convierteEntero(bitacoraSegCobBean.getRespuestaID()));
								sentenciaStore.setString("Par_Comentario",bitacoraSegCobBean.getComentario());
								sentenciaStore.setString("Par_EtapaCobranza",bitacoraSegCobBean.getEtapaCobranza());
								sentenciaStore.setString("Par_FechaEtregaDoc",Utileria.convierteFecha(bitacoraSegCobBean.getFechaEntregaDoc()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BitacoraSegCobDAO.altaBitacoraSegCob");
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
						throw new Exception(Constantes.MSG_ERROR + " .BitacoraSegCobDAO.altaBitacoraSegCob");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de bitacora de seguimiento de cobranza" + e);
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

	//Alta promesa
	public MensajeTransaccionBean altaPromesa(final BitacoraSegCobBean bitacoraSegCobBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PROMESASEGCOBALT(" +
									"?,?,?,?,?,	 ?,?,?," +
									"?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_BitSegCobID",Utileria.convierteEntero(bitacoraSegCobBean.getBitSegCobID()));
								sentenciaStore.setInt("Par_NumPromesa",Utileria.convierteEntero(bitacoraSegCobBean.getNumPromesa()));
								sentenciaStore.setString("Par_FechaPromPago",Utileria.convierteFecha(bitacoraSegCobBean.getFechaPromPago()));
								sentenciaStore.setDouble("Par_MontoPromPago",Utileria.convierteDoble(bitacoraSegCobBean.getMontoPromPago()));
								sentenciaStore.setString("Par_ComentarioProm",bitacoraSegCobBean.getComentarioProm());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BitacoraSegCobDAO.altaPromesa");
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
						throw new Exception(Constantes.MSG_ERROR + " .BitacoraSegCobDAO.altaPromesa");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de promesa" + e);
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

	//lista con los registro de la bitacora para el reporte de excel
	public List reporteBitacoraSegCob(int tipoLista,RepBitacoraSegCobBean bitacoraBean){
		String query = "call BITACORASEGCOBREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteFecha(bitacoraBean.getFechaIniReg()),
				Utileria.convierteEntero(bitacoraBean.getCreditoID()),
				Utileria.convierteFecha(bitacoraBean.getFechaFinReg()),
				Utileria.convierteEntero(bitacoraBean.getUsuarioReg()),
				Utileria.convierteEntero(bitacoraBean.getAccionID()),

				Utileria.convierteFecha(bitacoraBean.getFechaIniProm()),
				Utileria.convierteEntero(bitacoraBean.getRespuestaID()),
				Utileria.convierteFecha(bitacoraBean.getFechaFinProm()),
				Utileria.convierteEntero(bitacoraBean.getClienteID()),
				Utileria.convierteEntero(bitacoraBean.getLimiteReglones()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"reporteBitacoraSegCob",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORASEGCOBREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepBitacoraSegCobBean repBitacoraSegCobBean = new RepBitacoraSegCobBean();

				repBitacoraSegCobBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				repBitacoraSegCobBean.setUsuarioID(resultSet.getString("UsuarioID"));
				repBitacoraSegCobBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				repBitacoraSegCobBean.setCreditoID(resultSet.getString("CreditoID"));
				repBitacoraSegCobBean.setClienteID(resultSet.getString("ClienteID"));

				repBitacoraSegCobBean.setDescAccion(resultSet.getString("DescAccion"));
				repBitacoraSegCobBean.setDescRespuesta(resultSet.getString("DescRespuesta"));
				repBitacoraSegCobBean.setComentarios(resultSet.getString("Comentarios"));
				repBitacoraSegCobBean.setEtapaCobranza(resultSet.getString("EtapaCobranza"));
				repBitacoraSegCobBean.setFechaEntregaDoc(resultSet.getString("FechaEntregaDoc"));

				repBitacoraSegCobBean.setFechaPromPago(resultSet.getString("FechaPromPago"));
				repBitacoraSegCobBean.setMontoPromPago(resultSet.getString("MontoPromPago"));
				repBitacoraSegCobBean.setComentariosProm(resultSet.getString("ComentariosProm"));
				repBitacoraSegCobBean.setNombreCliente(resultSet.getString("NombreCliente"));
				repBitacoraSegCobBean.setClaveUsuario(resultSet.getString("ClaveUsuario"));

				return repBitacoraSegCobBean;
			}
		});
		return matches;
	}

	//Lista para el grid con las promesas
	public List promesasSegCob(int tipoLista, BitacoraSegCobBean bitacoraSegCobBean){
		String query = "call PROMESASEGCOBLIS(?,?, ?,?,?, ?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteLong(bitacoraSegCobBean.getCreditoID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"BitacoraSegCobDAO.promesasSegCob",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMESASEGCOBLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				BitacoraSegCobBean bean = new BitacoraSegCobBean();

				bean.setNumPromesa(resultSet.getString("NumPromesa"));
				bean.setFechaPromPago(resultSet.getString("FechaPromPago"));
				bean.setMontoPromPago(resultSet.getString("MontoPromPago"));
				bean.setComentarioProm(resultSet.getString("ComentarioProm"));

				return bean;
			}
		});

		return matches;
	}
}
