package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import java.sql.ResultSetMetaData;

import tesoreria.bean.DetalleImpuestoBean;
import tesoreria.bean.DetallefactprovBean;
import tesoreria.bean.FacturaprovBean;


public class FacturaprovDAO extends BaseDAO  {

	DetallefactprovDAO detallefactprovDAO = null;
	DetalleImpuestoDAO detalleImpuestoDAO = null;

	public FacturaprovDAO() {
		super();
	}

	public MensajeTransaccionBean altaFacturaMasiva(final FacturaprovBean facturaprovBean, final long numTransaccion ) {
		//SETEAMOS EL ESTATUS A A.-ACTIVO
		facturaprovBean.setEstatus("A");
 		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call FACTURAPROVALTPRO(?,?,?,?,?,		"+
																	  "?,?,?,?,?,		"+
																	  "?,?,?,?,?,		"+
																	  "?,?,?,?,?,		"+
																	  "?,?,?,?,?,		"+
																	  "?,?,?,?,?,		"+
																	  "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_FechFactura",Utileria.convierteFecha(facturaprovBean.getFechaFactura()));
								sentenciaStore.setString("Par_Estatus",facturaprovBean.getEstatus());
								sentenciaStore.setInt("Par_CondicPago",Utileria.convierteEntero(facturaprovBean.getCondicionesPago()));

								sentenciaStore.setString("Par_FechProgPag",Utileria.convierteFecha(facturaprovBean.getFechaProgPago()));
								sentenciaStore.setString("Par_FechaVenc",Utileria.convierteFecha(facturaprovBean.getFechaVencimiento()));
								sentenciaStore.setDouble("Par_SaldoFact",Utileria.convierteDoble(facturaprovBean.getSaldoFactura()));
								sentenciaStore.setDouble("Par_TotalGrava",Utileria.convierteDoble(facturaprovBean.getTotalGravable()));
								sentenciaStore.setDouble("Par_TotalFact",Utileria.convierteDoble(facturaprovBean.getTotalFactura()));

								sentenciaStore.setDouble("Par_SubTotal",Utileria.convierteDoble(facturaprovBean.getSubTotal()));
								sentenciaStore.setString("Par_PagoAnticipado", facturaprovBean.getPagoAnticipado());

								sentenciaStore.setString("Par_TipoPagoAnt", facturaprovBean.getTipoPagoAnt());
								sentenciaStore.setInt("Par_EmpleadoID",Utileria.convierteEntero(facturaprovBean.getNoEmpleadoID()));
								sentenciaStore.setInt("Par_CenCostoAntID", Utileria.convierteEntero(facturaprovBean.getCenCostoAntID()));
								sentenciaStore.setInt("Par_CenCostoManualID",Utileria.convierteEntero(facturaprovBean.getCenCostoManualID()));
								sentenciaStore.setString("Par_ProrrateaImp",facturaprovBean.getProrrateaImp());

								sentenciaStore.setString("Par_RutaImgFac",facturaprovBean.getRutaImagenFact());
								sentenciaStore.setString("Par_RutaXMLFac",facturaprovBean.getRutaXMLFact());
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());
								sentenciaStore.setString("Par_GeneraConta",Constantes.salidaSI);
								sentenciaStore.setString("Par_OrigenProceso","FP");

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de factura masiva", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaFactura(final FacturaprovBean facturaprovBean){
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
								String query = "call FACTURAPROVALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_FechFactura",Utileria.convierteFecha(facturaprovBean.getFechaFactura()));
								sentenciaStore.setString("Par_Estatus",facturaprovBean.getEstatus());
								sentenciaStore.setInt("Par_CondicPago",Utileria.convierteEntero(facturaprovBean.getCondicionesPago()));
								sentenciaStore.setString("Par_FechProgPag",Utileria.convierteFecha(facturaprovBean.getFechaProgPago()));
								sentenciaStore.setString("Par_FechaVenc",Utileria.convierteFecha(facturaprovBean.getFechaVencimiento()));
								sentenciaStore.setDouble("Par_SaldoFact",Utileria.convierteDoble(facturaprovBean.getSaldoFactura()));
								sentenciaStore.setDouble("Par_TotalGrava",Utileria.convierteDoble(facturaprovBean.getTotalGravable()));
								sentenciaStore.setDouble("Par_TotalFact",Utileria.convierteDoble(facturaprovBean.getTotalFactura()));
								sentenciaStore.setDouble("Par_SubTotal",Utileria.convierteDoble(facturaprovBean.getSubTotal()));
								sentenciaStore.setString("Par_RutaImgFac",facturaprovBean.getRutaImagenFact());
								sentenciaStore.setString("Par_RutaXMLFac",facturaprovBean.getRutaXMLFact());
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());


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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de factura", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean altaFactura(final FacturaprovBean facturaprovBean, final long numTransaccion ) {
 		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call FACTURAPROVALT(?,?,?,?,?,	?,?,?,?,?,	"
																 + "?,?,?,?,?,	?,?,?,?,?,"
																 + "?,?,	?,?,?,?,?,"
																 + "?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_FechFactura",Utileria.convierteFecha(facturaprovBean.getFechaFactura()));
								sentenciaStore.setString("Par_Estatus",facturaprovBean.getEstatus());
								sentenciaStore.setInt("Par_CondicPago",Utileria.convierteEntero(facturaprovBean.getCondicionesPago()));

								sentenciaStore.setString("Par_FechProgPag",Utileria.convierteFecha(facturaprovBean.getFechaProgPago()));
								sentenciaStore.setString("Par_FechaVenc",Utileria.convierteFecha(facturaprovBean.getFechaVencimiento()));
								sentenciaStore.setDouble("Par_SaldoFact",Utileria.convierteDoble(facturaprovBean.getSaldoFactura()));
								sentenciaStore.setDouble("Par_TotalGrava",Utileria.convierteDoble(facturaprovBean.getTotalGravable()));
								sentenciaStore.setDouble("Par_TotalFact",Utileria.convierteDoble(facturaprovBean.getTotalFactura()));

								sentenciaStore.setDouble("Par_SubTotal",Utileria.convierteDoble(facturaprovBean.getSubTotal()));
								sentenciaStore.setString("Par_PagoAnticipado", facturaprovBean.getPagoAnticipado());

								sentenciaStore.setString("Par_TipoPagoAnt", facturaprovBean.getTipoPagoAnt());
								sentenciaStore.setInt("Par_EmpleadoID",Utileria.convierteEntero(facturaprovBean.getNoEmpleadoID()));
								sentenciaStore.setInt("Par_CenCostoAntID", Utileria.convierteEntero(facturaprovBean.getCenCostoAntID()));
								sentenciaStore.setInt("Par_CenCostoManualID",Utileria.convierteEntero(facturaprovBean.getCenCostoManualID()));
								sentenciaStore.setString("Par_ProrrateaImp",facturaprovBean.getProrrateaImp());

								sentenciaStore.setString("Par_RutaImgFac",facturaprovBean.getRutaImagenFact());
								sentenciaStore.setString("Par_RutaXMLFac",facturaprovBean.getRutaXMLFact());
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de factura", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Metodo para dar de alta la factura y su detalle
	public MensajeTransaccionBean grabaListaDetalleFactura(final FacturaprovBean facturaprovBean, final List listaDetalleFactura, final List listaDetalleFacturaImp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					DetallefactprovBean detallefactprovBean;
					DetalleImpuestoBean detallefactprovimpBean;
					String proveedor= facturaprovBean.getProveedorID();
					String noFactura= facturaprovBean.getNoFactura();

					mensajeBean = altaFactura(facturaprovBean, parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String noPoliza= mensajeBean.getConsecutivoString();
					String facturaID = "0";

					for(int i=0; i<listaDetalleFactura.size(); i++){
						detallefactprovBean = (DetallefactprovBean)listaDetalleFactura.get(i);
						detallefactprovBean.setNoFactura(noFactura);
						detallefactprovBean.setNoPartidaID(noPoliza);
						detallefactprovBean.setProveedorID(proveedor);
						detallefactprovBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						detallefactprovBean.setFechaFactura(facturaprovBean.getFechaFactura());
						detallefactprovBean.setProrrateaImp(facturaprovBean.getProrrateaImp());
						detallefactprovBean.setPagoAnticipado(facturaprovBean.getPagoAnticipado());
						detallefactprovBean.setTipoPagoAnt(facturaprovBean.getTipoPagoAnt());
						detallefactprovBean.setCenCostoAntID(facturaprovBean.getCenCostoAntID());
						detallefactprovBean.setCenCostoManualID(facturaprovBean.getCenCostoManualID());
						detallefactprovBean.setNoEmpleadoID(facturaprovBean.getNoEmpleadoID());

						mensajeBean = detallefactprovDAO.altaDetalleFactura(detallefactprovBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						facturaID= mensajeBean.getConsecutivoString();

					}

					for(int i=0; i<listaDetalleFacturaImp.size(); i++){
						detallefactprovimpBean = (DetalleImpuestoBean)listaDetalleFacturaImp.get(i);
						detallefactprovimpBean.setProveedorID(proveedor);
						detallefactprovimpBean.setNoFactura(noFactura);
						detallefactprovimpBean.setPagoAnticipado(facturaprovBean.getPagoAnticipado());
						detallefactprovimpBean.setTipoPagoAnt(facturaprovBean.getTipoPagoAnt());
						detallefactprovimpBean.setFechaFactura(facturaprovBean.getFechaFactura());
						detallefactprovimpBean.setCenCostoAntID(facturaprovBean.getCenCostoAntID());
						detallefactprovimpBean.setCenCostoManualID(facturaprovBean.getCenCostoManualID());
						detallefactprovimpBean.setNoEmpleadoID(facturaprovBean.getNoEmpleadoID());
						detallefactprovimpBean.setFolioUUID(facturaprovBean.getFolioUUID());
						detallefactprovimpBean.setPoliza(noPoliza);
						detallefactprovimpBean.setProrrateaImp(facturaprovBean.getProrrateaImp());
						detallefactprovimpBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));


						mensajeBean = detalleImpuestoDAO.altaDetalleImpuesto(detallefactprovimpBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						facturaID= mensajeBean.getConsecutivoString();

					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion(" Factura Agregada con Folio: "+noFactura +". \n"+ "Poliza de la Factura: " +noPoliza);


					mensajeBean.setNombreControl("polizaID");
					mensajeBean.setConsecutivoString(facturaID);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de detalles de factura", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Metodo para dar modificar la factura y su detalle y dar de alta la contabilidad del proceso Masivo
		public MensajeTransaccionBean modificaListaDetalleFactura(final FacturaprovBean facturaprovBean, final List listaDetalleFactura, final List listaDetalleFacturaImp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						DetallefactprovBean detallefactprovBean;
						DetalleImpuestoBean detallefactprovimpBean;
						String proveedor= facturaprovBean.getProveedorID();
						String noFactura= facturaprovBean.getNoFactura();

						//DAMOS DE BAJA EL DETALLE DE LA FACTURA MASIVA
						mensajeBean = detallefactprovDAO.bajaDetalleFacturaMasiva(facturaprovBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}


						// GENERAMOS LA CONTABILIDAD DE LA FACTURA
						mensajeBean = altaFacturaMasiva(facturaprovBean, parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						String noPoliza= mensajeBean.getConsecutivoString();
						String facturaID = "0";

						for(int i=0; i<listaDetalleFactura.size(); i++){
							detallefactprovBean = (DetallefactprovBean)listaDetalleFactura.get(i);
							detallefactprovBean.setNoFactura(noFactura);
							detallefactprovBean.setNoPartidaID(noPoliza);
							detallefactprovBean.setProveedorID(proveedor);
							detallefactprovBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							detallefactprovBean.setFechaFactura(facturaprovBean.getFechaFactura());
							detallefactprovBean.setProrrateaImp(facturaprovBean.getProrrateaImp());
							detallefactprovBean.setPagoAnticipado(facturaprovBean.getPagoAnticipado());
							detallefactprovBean.setTipoPagoAnt(facturaprovBean.getTipoPagoAnt());
							detallefactprovBean.setCenCostoAntID(facturaprovBean.getCenCostoAntID());
							detallefactprovBean.setCenCostoManualID(facturaprovBean.getCenCostoManualID());
							detallefactprovBean.setNoEmpleadoID(facturaprovBean.getNoEmpleadoID());

							mensajeBean = detallefactprovDAO.altaDetalleFacturaMasiva(detallefactprovBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							facturaID= mensajeBean.getConsecutivoString();

						}

						for(int i=0; i<listaDetalleFacturaImp.size(); i++){
							detallefactprovimpBean = (DetalleImpuestoBean)listaDetalleFacturaImp.get(i);
							detallefactprovimpBean.setProveedorID(proveedor);
							detallefactprovimpBean.setNoFactura(noFactura);
							detallefactprovimpBean.setPagoAnticipado(facturaprovBean.getPagoAnticipado());
							detallefactprovimpBean.setTipoPagoAnt(facturaprovBean.getTipoPagoAnt());
							detallefactprovimpBean.setFechaFactura(facturaprovBean.getFechaFactura());
							detallefactprovimpBean.setCenCostoAntID(facturaprovBean.getCenCostoAntID());
							detallefactprovimpBean.setCenCostoManualID(facturaprovBean.getCenCostoManualID());
							detallefactprovimpBean.setNoEmpleadoID(facturaprovBean.getNoEmpleadoID());
							detallefactprovimpBean.setFolioUUID(facturaprovBean.getFolioUUID());
							detallefactprovimpBean.setPoliza(noPoliza);
							detallefactprovimpBean.setProrrateaImp(facturaprovBean.getProrrateaImp());
							detallefactprovimpBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));


							mensajeBean = detalleImpuestoDAO.altaDetalleImpuesto(detallefactprovimpBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							facturaID= mensajeBean.getConsecutivoString();

						}
						//ACTUALIZAMOS EL ESTATUS DE LA FACTURA A ACTIVA
						mensajeBean = cancelarFactura(facturaprovBean,8);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion(" Factura Agregada con Folio: "+noFactura +". \n"+ "Poliza de la Factura: " +noPoliza);


						mensajeBean.setNombreControl("polizaID");
						mensajeBean.setConsecutivoString(facturaID);
					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de detalles de factura", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Cancelacion de Factura
	public MensajeTransaccionBean cancelarFactura(final FacturaprovBean facturaprovBean, final int tipoActualizacion) {
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
								String query = "call FACTURAPROVACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_RutaImgFact",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_RutaXMLFact",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivoCancela",facturaprovBean.getMotivoCancelacion());
								sentenciaStore.setString("Par_Monto",facturaprovBean.getMonto());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de factura", e);
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

	// actualiza ruta del archivo subido de la factura
	public MensajeTransaccionBean actualizaRutaArchivoFactura(final FacturaprovBean facturaprovBean, final int tipoActualizacion) {
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
								String query = "call FACTURAPROVACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_RutaImgFact",facturaprovBean.getRutaImagenFact());
								sentenciaStore.setString("Par_RutaXMLFact",facturaprovBean.getRutaXMLFact());
								sentenciaStore.setString("Par_MotivoCancela",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Monto",facturaprovBean.getMonto());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza ruta dearchivo", e);
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



	// actualiza Foliouuid
	public MensajeTransaccionBean actualizaFolioUUID(final FacturaprovBean facturaprovBean, final int tipoActualizacion) {
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
								String query = "call FACTURAPROVACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",facturaprovBean.getNoFactura());
								sentenciaStore.setString("Par_RutaImgFact",facturaprovBean.getRutaImagenFact());
								sentenciaStore.setString("Par_RutaXMLFact",facturaprovBean.getRutaXMLFact());
								sentenciaStore.setString("Par_MotivoCancela",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Monto",facturaprovBean.getMonto());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_FolioUUID",facturaprovBean.getFolioUUID());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza ruta dearchivo", e);
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


	//Consulta principal de Factura
	public FacturaprovBean consultaPrincipal(FacturaprovBean facturaprovBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call FACTURAPROVCON(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = { facturaprovBean.getNoFactura(),
								Utileria.convierteEntero(facturaprovBean.getProveedorID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setProveedorID(String.valueOf(resultSet.getInt(1)));
				facturaprovBean.setNoFactura(resultSet.getString(2));
				facturaprovBean.setFechaFactura(resultSet.getString(3));
				facturaprovBean.setEstatus(resultSet.getString(4));
				facturaprovBean.setCondicionesPago(String.valueOf(resultSet.getInt(5)));
				facturaprovBean.setFechaProgPago(resultSet.getString(6));
				facturaprovBean.setFechaVencimiento(resultSet.getString(7));
				facturaprovBean.setSaldoFactura(String.valueOf(resultSet.getDouble(8)));
				facturaprovBean.setTotalGravable(String.valueOf(resultSet.getDouble(9)));
				facturaprovBean.setTotalFactura(String.valueOf(resultSet.getDouble(10)));
				facturaprovBean.setSubTotal(String.valueOf(resultSet.getDouble(11)));
				facturaprovBean.setRutaImagenFact(resultSet.getString(12));
				facturaprovBean.setRutaXMLFact(resultSet.getString(13));
				facturaprovBean.setMotivoCancelacion(resultSet.getString(14));
				facturaprovBean.setFechaCancelacion(resultSet.getString(15));
				facturaprovBean.setPagoAnticipado(resultSet.getString(16));
				facturaprovBean.setCenCostoManualID(resultSet.getString(17));
				facturaprovBean.setProrrateaImp(resultSet.getString(18));
				facturaprovBean.setTipoPagoAnt(resultSet.getString(19));
				facturaprovBean.setCenCostoAntID(resultSet.getString(20));
				facturaprovBean.setNoEmpleadoID(resultSet.getString(21));
				facturaprovBean.setFolioUUID(resultSet.getString(22));
				facturaprovBean.setTotGravado(resultSet.getString(23));
				facturaprovBean.setTotRetenido(resultSet.getString(24));
				facturaprovBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				facturaprovBean.setFolioFacturaID(resultSet.getString("FolioFacturaID"));
				facturaprovBean.setMesSubirFact(resultSet.getString("MesSubirFact"));

				return facturaprovBean;
			}
		});
		return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
	}

	//Consulta foranea de Factura
		public FacturaprovBean consultaForanea(FacturaprovBean facturaprovBean, int tipoConsulta) {
			FacturaprovBean facturaProvBean = new FacturaprovBean();
			try{
				//Query con el Store Procedure
				String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = { facturaprovBean.getNoFactura(),
										Utileria.convierteEntero(facturaprovBean.getProveedorID()),
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						FacturaprovBean facturaprovBean = new FacturaprovBean();
						facturaprovBean.setProveedorID(resultSet.getString("ProveedorID"));
						facturaprovBean.setNoFactura(resultSet.getString("NoFactura"));
						facturaprovBean.setFechaFactura(resultSet.getString("FechaFactura"));
						facturaprovBean.setEstatus(resultSet.getString("Estatus"));
						facturaprovBean.setCondicionesPago(resultSet.getString("CondicionesPago"));
						facturaprovBean.setFechaProgPago(resultSet.getString("FechaProgPago"));
						facturaprovBean.setFechaVencimiento(resultSet.getString("FechaVencimient"));
						facturaprovBean.setSaldoFactura(resultSet.getString("SaldoFactura"));
						facturaprovBean.setTotalGravable(resultSet.getString("TotalGravable"));
						facturaprovBean.setTotalFactura(resultSet.getString("TotalFactura"));
						facturaprovBean.setSubTotal(resultSet.getString("SubTotal"));
						return facturaprovBean;
					}
				});
				facturaProvBean = matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta foranea de factura", e);
			}
			return facturaProvBean;
		}


		//Consulta anticipo de Factura
		public FacturaprovBean consultaAnticipo(FacturaprovBean facturaprovBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { facturaprovBean.getNoFactura(),
									Utileria.convierteEntero(facturaprovBean.getProveedorID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FacturaprovBean facturaprovBean = new FacturaprovBean();
					facturaprovBean.setProveedorID(String.valueOf(resultSet.getInt(1)));
					facturaprovBean.setNoFactura(resultSet.getString(2));
					facturaprovBean.setFechaFactura(resultSet.getString(3));
					facturaprovBean.setEstatus(resultSet.getString(4));
					facturaprovBean.setCondicionesPago(String.valueOf(resultSet.getInt(5)));
					facturaprovBean.setFechaProgPago(resultSet.getString(6));
					facturaprovBean.setFechaVencimiento(resultSet.getString(7));
					facturaprovBean.setSaldoFactura(String.valueOf(resultSet.getDouble(8)));
					facturaprovBean.setTotalGravable(String.valueOf(resultSet.getDouble(9)));
					facturaprovBean.setTotalFactura(String.valueOf(resultSet.getDouble(10)));
					facturaprovBean.setSubTotal(String.valueOf(resultSet.getDouble(11)));
					facturaprovBean.setRutaImagenFact(resultSet.getString(12));
					facturaprovBean.setRutaXMLFact(resultSet.getString(13));
					facturaprovBean.setMotivoCancelacion(resultSet.getString(14));
					facturaprovBean.setFechaCancelacion(resultSet.getString(15));
					facturaprovBean.setEstatusReq(resultSet.getString(16));

					return facturaprovBean;
				}
			});
			return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
		}


		//Consulta anticipo de Factura
		public FacturaprovBean consultaPolizaFactura(FacturaprovBean facturaprovBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { facturaprovBean.getNoFactura(),
									Utileria.convierteEntero(facturaprovBean.getProveedorID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FacturaprovBean facturaprovBean = new FacturaprovBean();
					facturaprovBean.setPolizaID(String.valueOf(resultSet.getInt(1)));
					return facturaprovBean;
				}
			});
			return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
		}

		//Consulta estatus de periodo contable de Factura
		public FacturaprovBean consultaPeriodoConFactura(FacturaprovBean facturaprovBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { facturaprovBean.getNoFactura(),
									Utileria.convierteEntero(facturaprovBean.getProveedorID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FacturaprovBean facturaprovBean = new FacturaprovBean();
					facturaprovBean.setEstatusPeriodo(String.valueOf(resultSet.getString(1)));
					return facturaprovBean;
				}
			});
			return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
		}

		//Consulta si al factura ya esta en una dispersion
		public FacturaprovBean consultaDispersionFactura(FacturaprovBean facturaprovBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { facturaprovBean.getNoFactura(),
									Utileria.convierteEntero(facturaprovBean.getProveedorID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FacturaprovBean facturaprovBean = new FacturaprovBean();
					facturaprovBean.setNumDisp(String.valueOf(resultSet.getInt(1)));
					return facturaprovBean;
				}
			});
			return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
		}

		//Consulta si al factura ya esta en una dispersion
		public FacturaprovBean consultaAnticipoFactura(FacturaprovBean facturaprovBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call FACTURAPROVCON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { facturaprovBean.getNoFactura(),
									Utileria.convierteEntero(facturaprovBean.getProveedorID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FacturaprovBean facturaprovBean = new FacturaprovBean();
					facturaprovBean.setNumAnticipos(String.valueOf(resultSet.getInt(1)));
					return facturaprovBean;
				}
			});
			return matches.size() > 0 ? (FacturaprovBean) matches.get(0) : null;
		}



	public List listaFacturaProveedor(FacturaprovBean facturaprovBean, int tipoLista){
		String query = "call FACTURAPROVLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					facturaprovBean.getNoFactura(),
					Utileria.convierteEntero(facturaprovBean.getProveedorID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setNoFactura(resultSet.getString(1));
				facturaprovBean.setFacturaProvID(resultSet.getString(2));
				facturaprovBean.setEstatus(resultSet.getString(3));
				facturaprovBean.setProveedorID(resultSet.getString(4));
				return facturaprovBean;
			}
		});
		return matches;
	}

	//  Lista de facturas filtradas por proveedor y estatus no pagado
	public List listaFacturaPorProveedor(FacturaprovBean facturaprovBean, int tipoLista){

		String query = "call FACTURAPROVLIS(?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
					facturaprovBean.getNoFactura(),
					Utileria.convierteEntero(facturaprovBean.getProveedorID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setNoFactura(resultSet.getString(1));
				facturaprovBean.setFacturaProvID(resultSet.getString(2));
				facturaprovBean.setEstatus(resultSet.getString(3));
				facturaprovBean.setProveedorID(resultSet.getString(4));
				return facturaprovBean;
			}
		});
		return matches;
	}

	//  Lista de facturas filtradas por Estatus Alta o parcialmente Pagadas
	public List listaFacturaEstAltaParcial(FacturaprovBean facturaprovBean, int tipoLista){
		String query = "call FACTURAPROVLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					facturaprovBean.getNoFactura(),
					Utileria.convierteEntero(facturaprovBean.getProveedorID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setNoFactura(resultSet.getString(1));
				facturaprovBean.setFacturaProvID(resultSet.getString(2));
				facturaprovBean.setEstatus(resultSet.getString(3));
				facturaprovBean.setProveedorID(resultSet.getString(4));
				return facturaprovBean;
			}
		});
		return matches;
	}

	//  Lista de facturas filtradas por Estatus Alta o parcialmente Pagadas por proveedor
	public List listaFacturaEstAltaParcialProve(FacturaprovBean facturaprovBean, int tipoLista){
		String query = "call FACTURAPROVLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					facturaprovBean.getNoFactura(),
					Utileria.convierteEntero(facturaprovBean.getProveedorIDFact()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setNoFactura(resultSet.getString(1));
				facturaprovBean.setFacturaProvID(resultSet.getString(2));
				facturaprovBean.setEstatus(resultSet.getString(3));
				facturaprovBean.setProveedorID(resultSet.getString(4));
				return facturaprovBean;
			}
		});
		return  matches;
	}


	/************************* REPORTE DE FACTURAS DINAMICO ************************************************/

	String listaResultado = "";
	public String conFacturaExcel(final FacturaprovBean facturaprovBean,int tipoLista){
		listaResultado = "";
		try{
			String query = "call FACTURAREP(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						facturaprovBean.getFechaInicio(),
						facturaprovBean.getFechaFin(),
						facturaprovBean.getEstatus(),
						facturaprovBean.getProveedorID(),
						facturaprovBean.getSucursal(),
						tipoLista,
						parametrosAuditoriaBean.getOrigenDatos(),
						Utileria.convierteEntero(facturaprovBean.getTipoCaptura()),
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						Constantes.STRING_VACIO,
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ResultSetMetaData metaDatos;
				int count = resultSet.getMetaData().getColumnCount();
				ArrayList listaValores = new ArrayList();
				for (int i = 1; i <= count; i++) {
					List valores = new ArrayList();
					valores.add(resultSet.getString(i));
					listaValores.add(valores);
					String valor = "";

					if(resultSet.getString(i)== null){
						valor ="0.00";
						}else if(resultSet.getString(i).equals("")){
							valor =" ";
						}else{
							valor = resultSet.getString(i);
						}
					listaResultado = listaResultado+valor +"]";
				}

				listaResultado = listaResultado+  "[";

				return listaValores;

			}
		});
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return listaResultado;
	}



//  Lista de facturas Pagadas en modo Detallado
	String listaResultadoDet = "";
	public String conFacExcelDetallado(final FacturaprovBean facturaprovBean,int tipoLista){
		listaResultadoDet = "";
		try{
			String query = "call FACTURAREP(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						facturaprovBean.getFechaInicio(),
						facturaprovBean.getFechaFin(),
						facturaprovBean.getEstatus(),
						facturaprovBean.getProveedorID(),
						facturaprovBean.getSucursal(),
						tipoLista,

						parametrosAuditoriaBean.getOrigenDatos(),
						Utileria.convierteEntero(facturaprovBean.getTipoCaptura()),
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						Constantes.STRING_VACIO,
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ResultSetMetaData metaDatos;
				int count = resultSet.getMetaData().getColumnCount();
				ArrayList listaValores = new ArrayList();
				for (int i = 1; i <= count; i++) {
					List valores = new ArrayList();
					valores.add(resultSet.getString(i));
					listaValores.add(valores);
					String valor = "";

					if(resultSet.getString(i)== null){
						valor ="0.00";
						}else if(resultSet.getString(i).equals("")){
							valor =" ";
						}else{
							valor = resultSet.getString(i);
						}
					listaResultadoDet = listaResultadoDet+valor +"]";
				}

				listaResultadoDet = listaResultadoDet+  "[";

				return listaValores;

			}
		});
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return listaResultadoDet;
	}



	/************************* encabezados REPORTE JAVA ************************************************/
	public List listaEncabezados(final FacturaprovBean facturaprovBean,int tipoLista){
		List listaResultado = null;
		try{
			String query = "call FACTURAREP(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						facturaprovBean.getFechaInicio(),
						facturaprovBean.getFechaFin(),
						facturaprovBean.getEstatus(),
						facturaprovBean.getProveedorID(),
						facturaprovBean.getSucursal(),
						tipoLista,

						parametrosAuditoriaBean.getOrigenDatos(),
						Utileria.convierteEntero(facturaprovBean.getTipoCaptura()),
						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						Constantes.STRING_VACIO,
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FacturaprovBean facturaprovBean = new FacturaprovBean();
				facturaprovBean.setColumnas(resultSet.getString("Columnas"));
				return facturaprovBean;
			}
		});
		listaResultado = matches;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return listaResultado;
	}


	public void setDetallefactprovDAO(DetallefactprovDAO detallefactprovDAO) {
		this.detallefactprovDAO = detallefactprovDAO;
	}

	public DetallefactprovDAO getDetallefactprovDAO() {
		return detallefactprovDAO;
	}


	public DetalleImpuestoDAO getDetalleImpuestoDAO() {
		return detalleImpuestoDAO;
	}


	public void setDetalleImpuestoDAO(DetalleImpuestoDAO detalleImpuestoDAO) {
		this.detalleImpuestoDAO = detalleImpuestoDAO;
	}


}


