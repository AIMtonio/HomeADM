package spei.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.rmi.RemoteException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;

import cliente.bean.ClienteBean;
import spei.bean.DescargaRemesasBean;
import spei.bean.PagoRemesaSPEIBean;
import spei.bean.RemesasBean;
import spei.bean.RemesasWSBean;
import spei.servicioweb.Service1SoapProxy;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;

public class DescargaRemesasDAO extends BaseDAO  {

	private ParamGeneralesDAO paramGeneralesDAO = null;
	private Service1SoapProxy service1SoapProxy = null;
	private RemesasDAO remesasDAO = null;

	final String			saltoLinea				= " <br> ";
	private long			start					= 0;
	private double			tiempo					= 0;
	private double			end						= 0;
	final boolean			origenVent				= true;
	boolean 				excepcionTimedOut		= false;
	String 					rcode					= "";

	public final static String[] Error_TimeOut 	= {
		"Read timed out",
		"Connection timed out",
		"Expiró el tiempo de conexión (Connection timed out)",
		"Expiró el tiempo de conexión",
		"connect timed out"
	};

	public DescargaRemesasDAO() {
		super();
	}

	// Actualiza el estatus
	public MensajeTransaccionBean altaSolicitudDescarga(final DescargaRemesasBean descargaRemesasBean, final int tipoTramsaccion) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try{
			// Query con el Store Procedure
	mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call SPEISOLDESREMALT(?,?,?,?,?, ?,?,?,?,?,"
														   + "?,?,?,?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setString("Par_SpeiSolDesID",descargaRemesasBean.getSpeiSolDesID());
						sentenciaStore.setString("Par_FechaRegistro",descargaRemesasBean.getFechaRegistro());
						sentenciaStore.setString("Par_Estatus",descargaRemesasBean.getEstatus());
						sentenciaStore.setString("Par_FechaProceso",Constantes.FECHA_VACIA);

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
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta de solicitud de descarga", e);
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	public DescargaRemesasBean consultaSolDescarga(DescargaRemesasBean descargaRemesasBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SPEISOLDESREMCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
								descargaRemesasBean.getSpeiSolDesID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DescargaRemesasDAO.consultaSolDescarga",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEISOLDESREMCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DescargaRemesasBean descargaRemesasBean = new DescargaRemesasBean();
				descargaRemesasBean.setSpeiSolDesID(resultSet.getString("SpeiSolDesID"));
				descargaRemesasBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				descargaRemesasBean.setFechaProceso(resultSet.getString("FechaProceso"));
				descargaRemesasBean.setEstatus(resultSet.getString("Estatus"));
				descargaRemesasBean.setUsuario(resultSet.getString("Usuario"));

					return descargaRemesasBean;

			}
		});
		return matches.size() > 0 ? (DescargaRemesasBean) matches.get(0) : null;

	}

	/* lista para traer  */
	public List listaSolDescargas(DescargaRemesasBean descargaRemesasBean, int tipoLista){
		String query = "call SPEISOLDESREMLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
					descargaRemesasBean.getSpeiSolDesID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEISOLDESREMLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DescargaRemesasBean descargaRemesasBean = new DescargaRemesasBean();
				descargaRemesasBean.setSpeiSolDesID(resultSet.getString(1));
				descargaRemesasBean.setEstatus(resultSet.getString(2));
				descargaRemesasBean.setFechaRegistro(resultSet.getString(3));


				return descargaRemesasBean;


			}
		});
		return matches;
	}

	/* lista para traer  */
	public List listaSolDescargasGrid(DescargaRemesasBean descargaRemesasBean, int tipoLista){
		String query = "call SPEISOLDESREMLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
					descargaRemesasBean.getSpeiSolDesID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					Constantes.STRING_VACIO,
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEISOLDESREMLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DescargaRemesasBean descargaRemesasBean = new DescargaRemesasBean();
				descargaRemesasBean.setSpeiSolDesID(resultSet.getString(1));
				descargaRemesasBean.setHora(resultSet.getString(2));
				descargaRemesasBean.setDescargas(resultSet.getString(3));
				descargaRemesasBean.setPendientes(resultSet.getString(4));
				descargaRemesasBean.setEnviados(resultSet.getString(5));


				return descargaRemesasBean;


			}
		});
		return matches;
	}

	public MensajeTransaccionBean altaSolRemesas(final DescargaRemesasBean descargaRemesasBean, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

			int tipoConConteo = 2;
			int numListNotif = 1;
			int tipoActProcesada = 1;
			List listaNotif = null;
			String mensajeDescripcion = "";
			try {
				// Alta cabecera solicitud descarga
				mensajeBean = altaSolicitudDescarga(descargaRemesasBean, tipoTransaccion);
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+mensajeBean.getNumero()+"-"+mensajeBean.getDescripcion()+":"+mensajeBean.getConsecutivoString());
				if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					throw new Exception(mensajeBean.getDescripcion());
				}

				String consecutivoString = mensajeBean.getConsecutivoString();

				// Alta SPEIREMESAS
				mensajeBean = altaRemesaSPEI(consecutivoString);
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+mensajeBean.getNumero()+"-"+mensajeBean.getDescripcion());

				if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					mensajeBean.setConsecutivoString("");
					throw new Exception(mensajeBean.getDescripcion());
				}
				
				mensajeDescripcion = mensajeBean.getDescripcion();

				descargaRemesasBean.setSpeiSolDesID(consecutivoString);

				mensajeBean = actualizaEstatusSol(descargaRemesasBean, tipoActProcesada);
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+mensajeBean.getNumero()+"-"+mensajeBean.getDescripcion());

				if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					mensajeBean.setConsecutivoString("");
					throw new Exception(mensajeBean.getDescripcion());
				}

				mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
				mensajeBean.setDescripcion(mensajeDescripcion);
				mensajeBean.setConsecutivoString(consecutivoString);
				
			} catch (Exception e) {
				if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en alta de Remesas", e);
			}
		return mensajeBean;
	}

	public MensajeTransaccionBean actualizaEstatusSol(final DescargaRemesasBean descargaRemesasBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try{
				// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SPEISOLDESREMACT(?,?,?,?,?,	?,?,?,?,?,	?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_SpeiSolDesID", Utileria.convierteLong(descargaRemesasBean.getSpeiSolDesID()));
							sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "DescargaRemesasDAO.actualizaEstatusSol");
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento De Parsiado De Información.");
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de solicitud de remesas", e);
				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
			}
		return mensajeBean;
	}

	public MensajeTransaccionBean altaRemesaSPEI(final String remesasBean) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Stored Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SPEIDESCARGASREMPRO(?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SpeiSolDesID",Utileria.convierteLong(remesasBean));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",getParametrosAuditoriaBean().getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", getParametrosAuditoriaBean().getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",getParametrosAuditoriaBean().getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","RemesasDAO.altaRemesas");
								sentenciaStore.setInt("Aud_Sucursal",getParametrosAuditoriaBean().getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", getParametrosAuditoriaBean().getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback<Object>() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
							DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " RemesasDAO.altaRemesaSPEI");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
						);
				if (mensajeBean == null) {
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception(Constantes.MSG_ERROR + " RemesasDAO.altaRemesaSPEI");
				} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					throw new Exception(mensajeBean.getDescripcion());
				}
			} catch (Exception e) {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al dar de alta la remesa" + e);
				e.printStackTrace();
				if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
			}
		return mensajeBean;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

	public Service1SoapProxy getService1SoapProxy() {
		return service1SoapProxy;
	}

	public void setService1SoapProxy(Service1SoapProxy service1SoapProxy) {
		this.service1SoapProxy = service1SoapProxy;
	}
}