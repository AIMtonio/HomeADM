package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;


import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import soporte.FacturacionElectronicaWS;
import soporte.bean.CancelaFacturaBean;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;

public class CancelaFacturaDAO extends BaseDAO{
	ParametrosSisServicio parametrosSisServicio=null;

	public CancelaFacturaDAO(){
		super();
	}

	public MensajeTransaccionBean cancelaFactura(final CancelaFacturaBean cancelaFacturaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		int tipoConsulta=5;
		ParametrosSisBean paramBean = new ParametrosSisBean();
		paramBean = parametrosSisServicio.consulta(tipoConsulta,paramBean);
		final String usuario=paramBean.getUsuarioFactElect(),password=paramBean.getPassFactElec(),rfc=paramBean.getRfcEmpresa(), urlSOAP = paramBean.getUrlWSDLFactElec();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String salidaMensajesLista="";
				try {
					FacturacionElectronicaWS facturacionElectronicaWS=new FacturacionElectronicaWS(urlSOAP,usuario,password,rfc);
					String salida=facturacionElectronicaWS.cancelarFactura(cancelaFacturaBean.getFolioFiscal());

					if(salida.contains("Exito")){
						salidaMensajesLista="Folio Fiscal enviado a la cola de cancelancion, espere unos minutos.";
						MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
						mensajeTransaccion=actualizaFolio(cancelaFacturaBean);
						//salidaMensajesLista=" "+mensajeTransaccion.getDescripcion();
					} else {
						String [] arraySalida=salida.split(" ");
						int descripcionError=2;
						for(int j=0;j<arraySalida.length;j++){
							if(j>=descripcionError){
								salidaMensajesLista+=arraySalida[j]+" ";
							}
						}
						if(salidaMensajesLista.contains("Formato Incorrecto de UUID")){
							salidaMensajesLista="Formato Incorrecto del Folio Fiscal";
						}else if(salidaMensajesLista.contains("UUID no existe")){
							salidaMensajesLista="El Folio Fiscal no existe";
						}else if(salidaMensajesLista.contains("Detalles de conexión requeridos")){
							salidaMensajesLista="Usuario o contraseña requeridos para la conexión";
						}
					}
					mensajeBean.setNumero(0);
			        mensajeBean.setDescripcion(salidaMensajesLista);
			        mensajeBean.setNombreControl(" ");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Ha ocurrido un problema durante la cancelacion de la factura");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la cancelacion de la factura ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Actualizacion del folio Fiscal a Cancelado */
	public MensajeTransaccionBean actualizaFolio(final CancelaFacturaBean cancelaFacturaBean) {
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
								String query = "call FACTURACFDIACT(?,?,?,?,?,	?,?,?,?,?,	?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_FolioFiscal",cancelaFacturaBean.getFolioFiscal());
								sentenciaStore.setString("Par_MotivoCancelacion",cancelaFacturaBean.getMotivo());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error Cancela Factura", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public List listaFolioFiscal(CancelaFacturaBean cancelaFacturaBean,int tipoConsulta){
		List cancelaFactura = null;
		try{
			String query = "call FACTURACFDILIS(?,?,?,?,?, ?,?,?,?,?,"
											+ "?,?,?);";
			Object[] parametros = { cancelaFacturaBean.getFolioFiscal().replace("_", "").replace("-", ""),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaListaFolios",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								 };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURACFDILIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
				throws SQLException {
					CancelaFacturaBean cancelaFacturaBean = new CancelaFacturaBean();

					cancelaFacturaBean.setFolioFiscal(resultSet.getString("FolioFiscal"));
					cancelaFacturaBean.setRfcReceptor(resultSet.getString("RFCReceptor"));
					cancelaFacturaBean.setRazonSocialReceptor(resultSet.getString("RazonSocialReceptor"));
					return cancelaFacturaBean;
				}
			});
			cancelaFactura = matches;
			}catch(Exception e){
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Principal de Cancela Factura", e);
			}
			return cancelaFactura;
	}

	public List listaGridPorFolio(CancelaFacturaBean cancelaFacturaBean, int tipoLista){
		List cancelaFactura = null;
		try{
			String query = "call FACTURACFDILIS(?,?,?,?,?, ?,?,?,?,?,"
											 + "?,?,?);";
			Object[] parametros = {
						cancelaFacturaBean.getFolioFiscal(),
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						tipoLista,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"DiasInversionDAO.lista",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURACFDILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CancelaFacturaBean cancelaFacturaBean = new CancelaFacturaBean();
					cancelaFacturaBean.setNumeroFiscal(resultSet.getString("FacturaID"));
					cancelaFacturaBean.setFolioFiscal(resultSet.getString("FolioFiscal"));;
					cancelaFacturaBean.setFechaEmision(resultSet.getString(3));
					cancelaFacturaBean.setRfcEmisor(resultSet.getString("RFCEmisor"));
					cancelaFacturaBean.setRazonSocialEmisor(resultSet.getString("RazonSocialEmisor"));
					cancelaFacturaBean.setRfcReceptor(resultSet.getString("RFCReceptor"));
					cancelaFacturaBean.setRazonSocialReceptor(resultSet.getString("RazonSocialReceptor"));
					cancelaFacturaBean.setTotalFactura(resultSet.getString("TotalFactura"));
					cancelaFacturaBean.setEstatus(resultSet.getString("Estatus"));
					cancelaFacturaBean.setMotivo(resultSet.getString("MotivoCancelacion"));
					cancelaFacturaBean.setPeriodo(resultSet.getString("Periodo"));
					cancelaFacturaBean.setCliente(resultSet.getString("ClienteID"));
					cancelaFacturaBean.setSucursalCliente(resultSet.getString("SucursalCliente"));
					return cancelaFacturaBean;
				}
			});
				cancelaFactura = matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista por folio de Cancela Factura", e);
			}
				return cancelaFactura;
	}

	public List listaGridPorFecha(CancelaFacturaBean cancelaFacturaBean, int tipoLista){
		List cancelaFactura = null;
		try{
			String query = "call FACTURACFDILIS(?,?,?,?,?, ?,?,?,?,?,"
											 + "?,?,?);";
			Object[] parametros = {
						Constantes.STRING_VACIO,
						cancelaFacturaBean.getFechaInicio(),
						cancelaFacturaBean.getFechaFin(),
						cancelaFacturaBean.getRfcReceptor(),
						cancelaFacturaBean.getEstatus(),
						tipoLista,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CancelaFacturaDAO.listaGridPorFecha",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURACFDILIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CancelaFacturaBean cancelaFacturaBean = new CancelaFacturaBean();
					cancelaFacturaBean.setNumeroFiscal(resultSet.getString("FacturaID"));
					cancelaFacturaBean.setFolioFiscal(resultSet.getString("FolioFiscal"));;
					cancelaFacturaBean.setFechaEmision(resultSet.getString(3));
					cancelaFacturaBean.setRfcEmisor(resultSet.getString("RFCEmisor"));
					cancelaFacturaBean.setRazonSocialEmisor(resultSet.getString("RazonSocialEmisor"));
					cancelaFacturaBean.setRfcReceptor(resultSet.getString("RFCReceptor"));
					cancelaFacturaBean.setRazonSocialReceptor(resultSet.getString("RazonSocialReceptor"));
					cancelaFacturaBean.setTotalFactura(resultSet.getString("TotalFactura"));
					cancelaFacturaBean.setEstatus(resultSet.getString("Estatus"));
					cancelaFacturaBean.setMotivo(resultSet.getString("MotivoCancelacion"));
					cancelaFacturaBean.setPeriodo(resultSet.getString("Periodo"));
					cancelaFacturaBean.setCliente(resultSet.getString("ClienteID"));
					cancelaFacturaBean.setSucursalCliente(resultSet.getString("SucursalCliente"));
					return cancelaFacturaBean;
				}
			});
			cancelaFactura = matches;
			}catch(Exception e){
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista por rango de fechas de Cancela Factura", e);
			}
				return cancelaFactura;
		}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}



}
