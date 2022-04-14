package nomina.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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

import nomina.bean.PagoNominaBean;
import nomina.bean.ReversaPagoNominaBean;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.InstitucionesBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.dao.CajasVentanillaDAO;

public class ReversaPagoNominaDAO extends BaseDAO{

	public ReversaPagoNominaDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	ParametrosSesionBean parametrosSesionBean;
	UsuarioServicio usuarioServicio = null;

	public MensajeTransaccionBean reversaPagoCreditoProceso(final ReversaPagoNominaBean reversaBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
				CajasVentanillaBean cajasVentanilla= new CajasVentanillaBean();
				UsuarioBean usuarioBean = new UsuarioBean();
				try {
					// se realiza la reversa del cargo y abono a cuenta, poliza contable, amortizaciones, y saldos del credito
					String passValidaUser = null;
					String presentedPassword = reversaBean.getContraseniaUsuarioAutoriza();
					/* -- -----------------------------------------------------------------
					 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
					 * -- -----------------------------------------------------------------
					 */
					usuarioBean.setClave(reversaBean.getUsuarioAutorizaID());
					usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
					if(usuarioBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(404);
						mensajeBean.setDescripcion("Usuario Invalido");
						return mensajeBean;
					}
					reversaBean.setUsuarioAutorizaID(usuarioBean.getClave());
			        if(presentedPassword.contains("HD>>")){
			        	loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Inicia Validacion de Token de Huella [ReversaPagoNominaDAO.reversaPagoCreditoProceso]");
			        	presentedPassword = presentedPassword.replace("HD>>", "");
			        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), presentedPassword));
			        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(reversaBean.getUsuarioAutorizaID());
			        	if(reversaBean.getContraseniaUsuarioAutoriza().equals(passValidaUser)){

			        		reversaBean.setContraseniaUsuarioAutoriza(usuarioBean.getContrasenia());
			        		mensajeBean = reversaPagoCredito(reversaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			        	}else{
			        		mensajeBean = new MensajeTransaccionBean();
			        		mensajeBean.setNumero(405);
			        		mensajeBean.setDescripcion("Token Huella Invalida");
			        	}
			        	loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Fin Validacion de Token de Huella [ReversaPagoNominaDAO.reversaPagoCreditoProceso]");
			        }else{
			        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), reversaBean.getContraseniaUsuarioAutoriza()));
						mensajeBean = reversaPagoCredito(reversaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			        }
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


					mensajeBean.setConsecutivoString(reversaBean.getFolioCargaID() + "-"+parametrosAuditoriaBean.getNumeroTransaccion() );


					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReversaPagoNominaDAO.reversaPagoCreditoProceso");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					return mensajeBean;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Pago De Credito", e);
				}

				return mensajeBean;
			}
		});
		mensaje.setCampoGenerico(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		return mensaje;
	}

	//********** METODO PARA LA REVERSA DEL PAGO DE CRÉDITO **********
		public MensajeTransaccionBean reversaPagoCredito(final ReversaPagoNominaBean reversaBean, final long numTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						//Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call REVERSAPAGCRENOMPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setLong("Par_InstNominaID",Utileria.convierteEntero(reversaBean.getInstitNominaID()));
										sentenciaStore.setLong("Par_FolioNominaID",Utileria.convierteEntero(reversaBean.getFolioCargaID()));
										sentenciaStore.setString("Par_UsuarioClave",reversaBean.getUsuarioAutorizaID());
										sentenciaStore.setString("Par_ContraseniaAut",reversaBean.getContraseniaUsuarioAutoriza());
										sentenciaStore.setString("Par_Motivo",reversaBean.getMotivo());

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										//Parametros de OutPut
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

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
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt(1)));
											mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
											mensajeTransaccion.setCampoGenerico(String.valueOf(numTransaccion));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReversaPagoNominaDAO.reversaPagoCredito");
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
							throw new Exception(Constantes.MSG_ERROR + " .ReversaPagoNominaDAO.reversaPagoCredito");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Pago De Credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Lista para el grid de Aplicacion de Pagos credito Nomina
		public List listaPagosGrid(ReversaPagoNominaBean reversaPagoNominaBean, int tipoLista) {
			List listaPagosNomina=null;
			try{
			String query = "call BEPAGOSAPLINOMINALIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									reversaPagoNominaBean.getInstitNominaID(),
									reversaPagoNominaBean.getFolioCargaID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ReversaPagoNominaDAO.listaPagosGrid",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BEPAGOSAPLINOMINALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReversaPagoNominaBean listaReversaPagos = new ReversaPagoNominaBean();

					listaReversaPagos.setCreditoID(resultSet.getString("CreditoID"));
					listaReversaPagos.setNoEmpleadoID(resultSet.getString("ClienteID"));
					listaReversaPagos.setFechaPago(resultSet.getString("FechaPago"));
					listaReversaPagos.setMontoAplicado(resultSet.getString("MontoAplicado"));
					listaReversaPagos.setProductoCredito(resultSet.getString("ProductoCredito"));

					return listaReversaPagos;
				}
			});

			listaPagosNomina= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Creditos de Nomina Pagados", e);
			}
			return listaPagosNomina;

			}

		// Lista los Folios Aplicados
		public List listaFolio(ReversaPagoNominaBean reversaPagoNominaBean, int tipoLista){
			String query = "call FOLIOSNOMINALIS(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {	reversaPagoNominaBean.getInstitNominaID(),
									reversaPagoNominaBean.getFolioCargaID(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ReversaPagoNominaDAO.listaFolio",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FOLIOSNOMINALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ReversaPagoNominaBean revPago = new ReversaPagoNominaBean();
					revPago.setFolioCargaID(resultSet.getString("FolioCargaID"));

					return revPago;

				}
			});
			return matches;
		}

		//Consulta de Folios de Nomina
	 	public ReversaPagoNominaBean consultaFolio(ReversaPagoNominaBean reversaPagoNominaBean, int tipoConsulta) {
	 		//Query con el Store Procedure
	 		String query = "call FOLIOSNOMINACON(?,?,?,	?,?,?,?,?,?,?);";
	 		Object[] parametros = {
	 								Utileria.convierteEntero(reversaPagoNominaBean.getInstitNominaID()),
	 								Utileria.convierteEntero(reversaPagoNominaBean.getFolioCargaID()),
	 								tipoConsulta,

	 								Constantes.ENTERO_CERO,
	 								Constantes.ENTERO_CERO,
	 								Constantes.FECHA_VACIA,
	 								Constantes.STRING_VACIO,
	 								"ReversaPagoNominaDAO.consultaFolio",
	 								Constantes.ENTERO_CERO,
	 								Constantes.ENTERO_CERO};
	 		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FOLIOSNOMINACON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
	 			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

	 				ReversaPagoNominaBean revPagosNom = new ReversaPagoNominaBean();
	 				revPagosNom.setFolioCargaID(resultSet.getString("FolioCargaID"));
	 				revPagosNom.setRegPendientes(resultSet.getString("RegPendientes"));
	 				revPagosNom.setEstatus(resultSet.getString("Estatus"));
	 				revPagosNom.setFechaApliPago(resultSet.getString("FechaApliPago"));
	 				return revPagosNom;

	 			}
	 		});
	 		return matches.size() > 0 ? (ReversaPagoNominaBean) matches.get(0) : null;

	 	}


		public UsuarioServicio getUsuarioServicio() {
			return usuarioServicio;
		}

		public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
			this.usuarioServicio = usuarioServicio;
		}

}
