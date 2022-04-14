package activos.dao;

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

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

import activos.bean.AplicacionDepreciacionBean;

public class AplicacionDepreciacionDAO extends BaseDAO{
	PolizaDAO polizaDAO = new PolizaDAO();

	public AplicacionDepreciacionDAO() {
		super();
	}

	// Metodo para generar el Numero de Poliza
	public MensajeTransaccionBean aplicacionDepreciacionAmortizacion(final AplicacionDepreciacionBean aplicacionDepreciacionBean, final int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();

			polizaBean.setConceptoID(aplicacionDepreciacionBean.concepContaDeprecia);
			polizaBean.setConcepto(aplicacionDepreciacionBean.descripConcepContaDeprecia+" "+aplicacionDepreciacionBean.getMes()+" "+aplicacionDepreciacionBean.getAnio());
			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String poliza = polizaBean.getPolizaID();
							try {
								aplicacionDepreciacionBean.setPolizaID(poliza);
								mensajeBean = aplicacionDepAmor(aplicacionDepreciacionBean, tipoTransaccion);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
							}
						 catch (Exception e) {
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la Aplicacion de Depreciacion y Amortizacion", e);
						}
						return mensajeBean;
					}
				});
				/* Baja de Poliza en caso de que haya ocurrido un error */
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(aplicacionDepreciacionBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);

				}
				/* Fin Baja de la Poliza Contable*/
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
			return mensaje;
		}

	/* Aplicacion de Depreciacion y Amortizacion de Activos */
	public MensajeTransaccionBean aplicacionDepAmor(final AplicacionDepreciacionBean aplicacionDepreciacionBean, final int tipoTransaccion) {
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
									String query = "call APLICADEPAMORTIZAACTIVOSPRO(?,?,?,?,?,	?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(aplicacionDepreciacionBean.getAnio()));
									sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(aplicacionDepreciacionBean.getMes()));
									sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(aplicacionDepreciacionBean.getUsuarioID()));
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(aplicacionDepreciacionBean.getSucursalID()));
									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(aplicacionDepreciacionBean.getPolizaID()));

									//Parametros de Salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ActivosDAO.aplicacionDepAmor");
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
							throw new Exception(Constantes.MSG_ERROR + " .ActivosDAO.aplicacionDepAmor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en aplicación de depreciación" + e);
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

	// Reporte Previo Aplicacion de Depreciacion y Amortizacion de Activos en Excel
	public List reporteDepreciaActivos(int tipoLista, final AplicacionDepreciacionBean aplicacionDepreciacionBean){
		List ListaResultado=null;
		try{
			String query = "call PREVIODEPAMORTIZAACTIVOSREP(?,?,?,?,?, ?,?,?,?)";

			Object[] parametros ={
					Utileria.convierteEntero(aplicacionDepreciacionBean.getAnio()),
					Utileria.convierteEntero(aplicacionDepreciacionBean.getMes()),

		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PREVIODEPAMORTIZAACTIVOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AplicacionDepreciacionBean aplicacionDepreciacionBean= new AplicacionDepreciacionBean();

					aplicacionDepreciacionBean.setActivoID(resultSet.getString("ActivoID"));
					aplicacionDepreciacionBean.setDescTipoActivo(resultSet.getString("DescTipoActivo"));
					aplicacionDepreciacionBean.setDescActivo(resultSet.getString("DescActivo"));
					aplicacionDepreciacionBean.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					aplicacionDepreciacionBean.setNumFactura(resultSet.getString("NumFactura"));

					aplicacionDepreciacionBean.setPoliza(resultSet.getString("Poliza"));
					aplicacionDepreciacionBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
					aplicacionDepreciacionBean.setMoi(resultSet.getString("Moi"));
					aplicacionDepreciacionBean.setDepreciacionAnual(resultSet.getString("DepreciacionAnual"));
					aplicacionDepreciacionBean.setTiempoAmortiMeses(resultSet.getString("TiempoAmortiMeses"));

		         	aplicacionDepreciacionBean.setDepreciaContaAnual(resultSet.getString("DepreciaContaAnual"));
					aplicacionDepreciacionBean.setEnero(resultSet.getString("Enero"));
					aplicacionDepreciacionBean.setFebrero(resultSet.getString("Febrero"));
					aplicacionDepreciacionBean.setMarzo(resultSet.getString("Marzo"));
					aplicacionDepreciacionBean.setAbril(resultSet.getString("Abril"));

					aplicacionDepreciacionBean.setMayo(resultSet.getString("Mayo"));
					aplicacionDepreciacionBean.setJunio(resultSet.getString("Junio"));
					aplicacionDepreciacionBean.setJulio(resultSet.getString("Julio"));
					aplicacionDepreciacionBean.setAgosto(resultSet.getString("Agosto"));
					aplicacionDepreciacionBean.setSeptiembre(resultSet.getString("Septiembre"));

					aplicacionDepreciacionBean.setOctubre(resultSet.getString("Octubre"));
					aplicacionDepreciacionBean.setNoviembre(resultSet.getString("Noviembre"));
					aplicacionDepreciacionBean.setDiciembre(resultSet.getString("Diciembre"));
					aplicacionDepreciacionBean.setDepreciadoAcumulado(resultSet.getString("DepreciadoAcumulado"));
					aplicacionDepreciacionBean.setSaldoPorDepreciar(resultSet.getString("SaldoPorDepreciar"));

					return aplicacionDepreciacionBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte previo de depreciacion y amortizacion de activos", e);
		}
		return ListaResultado;
	}

	/* LISTA ANIOS */
	public List listaAnios(int tipoLista,AplicacionDepreciacionBean apliDepreBean) {
		// Query con el Store Procedure
		String query = "call APLICADEPAMORTIZAACTIVOSLIS(?,?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"AplicacionDepreciacionDAO.listaAnios",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICADEPAMORTIZAACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				AplicacionDepreciacionBean bean = new AplicacionDepreciacionBean();

				bean.setAnio(resultSet.getString("Anio"));

				return bean;
			}
		});

		return matches;
	}

	/* LISTA ANIOS */
	public List listaMesesPorAnio(int tipoLista,AplicacionDepreciacionBean apliDepreBean) {
		// Query con el Store Procedure
		String query = "call APLICADEPAMORTIZAACTIVOSLIS(?,?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			Utileria.convierteEntero(apliDepreBean.getAnio()),
			Constantes.ENTERO_CERO,
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"AplicacionDepreciacionDAO.listaMesesPorAnio",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICADEPAMORTIZAACTIVOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				AplicacionDepreciacionBean bean = new AplicacionDepreciacionBean();

				bean.setMes(resultSet.getString("Mes"));
				bean.setDescMes(resultSet.getString("DescMes"));

				return bean;
			}
		});

		return matches;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
