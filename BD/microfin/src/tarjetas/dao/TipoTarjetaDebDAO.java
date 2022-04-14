package tarjetas.dao;
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
import tarjetas.bean.TipoTarjetaDebBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TipoTarjetaDebDAO extends BaseDAO{

	public TipoTarjetaDebDAO() {
		super();
	}

	/* Lista tipo de tarjetas de Debito */
	public List listaPrincipal(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
			String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = { tipoTarjetaDebBean.getTipoTarjeta(),
				                tipoTarjetaDebBean.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaPrincipalBDPrin",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));
				tipoTarjetaDeb.setTipoTarjeta(resultSet.getString("TipoTarjeta"));
				return tipoTarjetaDeb;
			}
		});
		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaPrincipal;
	}

	/* Lista tipo de tarjetas de Debito - BDPrincipal*/
	public List listaPrincipalBDPrincipal(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
			String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = { tipoTarjetaDebBean.getTipoTarjeta(),
				                tipoTarjetaDebBean.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaPrincipalBDPrin",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info("BDPrincipal"+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));
				tipoTarjetaDeb.setTipoTarjeta(resultSet.getString("TipoTarjeta"));
				return tipoTarjetaDeb;
			}
		});
		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("BDPrincipal"+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaPrincipal;
	}

	// lista de Tipos de Tarjetas filtrado por el id
	public List listaforanea(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaforanea=null;
		try{
		String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	 ?);";
		Object[] parametros = { Constantes.STRING_VACIO,
								tipoTarjetaDebBean.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));
				return tipoTarjetaDeb;
			}
		});
		listaforanea= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaforanea;
	}


	public List listaPorTipoCuenta(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaTipoTarjeta=null;
		try{
		String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	 ?);";
		Object[] parametros = { Constantes.STRING_VACIO,
								tipoTarjetaDebBean.getTipoTarjetaDebID(),
								tipoTarjetaDebBean.getCuentaAhoID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.listaTipoTarjetaporTipoCta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));

				return tipoTarjetaDeb;
			}
		});

		listaTipoTarjeta= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaTipoTarjeta;
	}





	public   TipoTarjetaDebBean consultaPrincipal(int tipoConsulta,TipoTarjetaDebBean tipoTarjeta) {
		//Query con el Store Procedure
		String query = "call TIPOTARJETADEBCON(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {	tipoTarjeta.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoTarjetaDebBean tipoTarjeta = new TipoTarjetaDebBean();

				tipoTarjeta.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjeta.setDescripcion(resultSet.getString(2));
				tipoTarjeta.setIdentificacionSocio(resultSet.getString(3));
				tipoTarjeta.setTipoTarjeta(resultSet.getString(4));
				tipoTarjeta.setTipoCore(resultSet.getString(5));
					return tipoTarjeta;

			}
		});
		return matches.size() > 0 ? (TipoTarjetaDebBean) matches.get(0) : null;

	}

	// consulta para los tipos de Tarjetas segun el Tipo de cuenta del cliente
	public   TipoTarjetaDebBean consultaForanea(int tipoTarjetaDebID, Long cuentaAhoID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOTARJETADEBCON(?,?,?, ?,?,?, ?,?,?, ?);";
		Object[] parametros = {	tipoTarjetaDebID,
								cuentaAhoID,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.foranea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoTarjetaDebBean tipoTarjeta = new TipoTarjetaDebBean();

				tipoTarjeta.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjeta.setDescripcion(resultSet.getString(2));
				tipoTarjeta.setMontoComision(resultSet.getString(3));
				tipoTarjeta.setIdentificacionSocio(resultSet.getString(4));

					return tipoTarjeta;

			}
		});
		return matches.size() > 0 ? (TipoTarjetaDebBean) matches.get(0) : null;
	}






////---------------------------tipo de tarjeta debito-----------------
	//-------------------------------insertar tipo de tarjeta---------------------------
public MensajeTransaccionBean tipoTarjetaDebito(final int tipoTransaccion, final TipoTarjetaDebBean tipoTarjetaDebBean) {

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

								String query = "call TIPOTARJETADEBITOALT(?, ?,?,?,?,?,    ?,?,?,?,?,    ?,?,?,?,?,	 ?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,	?,?,? ,?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_NumeroTipoTarjeta",tipoTarjetaDebBean.getNumeroTipoTarjeta());

								sentenciaStore.setString("Par_Descripcion",tipoTarjetaDebBean.getDescripcion());
								sentenciaStore.setString("Par_CompraPOS",tipoTarjetaDebBean.getCompraPOSLinea());
								sentenciaStore.setString("Par_Estatus",tipoTarjetaDebBean.getEstatus());
								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_IdentificaSocio",tipoTarjetaDebBean.getIdentificacionSocio());

								sentenciaStore.setString("Par_TipoProsaID", tipoTarjetaDebBean.getTipoProsaID());
								sentenciaStore.setInt("Par_VigenciaMeses", Utileria.convierteEntero(tipoTarjetaDebBean.getVigenciaMeses()));
								sentenciaStore.setString("Par_ColorTarjeta", tipoTarjetaDebBean.getColorTarjeta());
								sentenciaStore.setString("Par_TipoTarjeta", tipoTarjetaDebBean.getTipoTarjeta());
								sentenciaStore.setInt("Par_ProductoCredito", Utileria.convierteEntero(tipoTarjetaDebBean.getProductoCredito()));

								sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(tipoTarjetaDebBean.getTasaFija()));
								sentenciaStore.setDouble("Par_MontoAnual", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoAnual()));
								sentenciaStore.setString("Par_CobraMora", tipoTarjetaDebBean.getCobraMora());
								sentenciaStore.setString("Par_TipoMora", tipoTarjetaDebBean.getTipoMora());
								sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(tipoTarjetaDebBean.getFactorMora()));

								sentenciaStore.setString("Par_CobFalPago", tipoTarjetaDebBean.getCobFaltaPago());
								sentenciaStore.setString("Par_TipoFalPago", tipoTarjetaDebBean.getTipoFaltaPago());
								sentenciaStore.setDouble("Par_FacFalPago", Utileria.convierteDoble(tipoTarjetaDebBean.getFacFaltaPago()));
								sentenciaStore.setDouble("Par_PorcPagMin", Utileria.convierteDoble(tipoTarjetaDebBean.getPorcPagoMin()));
								sentenciaStore.setDouble("Par_MontoCredito", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoCredito()));

								sentenciaStore.setDouble("Par_FacComisionAper", Utileria.convierteDoble(tipoTarjetaDebBean.getFacComisionAper()));
								sentenciaStore.setString("Par_CobComisionAper", tipoTarjetaDebBean.getCobComisionAper());
								sentenciaStore.setString("Par_TipoCobComAper", tipoTarjetaDebBean.getTipoCobComAper());
								sentenciaStore.setInt("Par_TarBinParamsID", Utileria.convierteEntero(tipoTarjetaDebBean.getTarBinParamsID()));
								sentenciaStore.setString("Par_NumSubBIN", tipoTarjetaDebBean.getNumSubBIN());

								sentenciaStore.setString("Par_PatrocinadorID", tipoTarjetaDebBean.getPatrocinadorID());
								sentenciaStore.setInt("Par_TipoCore", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoCore()));
								sentenciaStore.setString("Par_UrlCore", tipoTarjetaDebBean.getUrlCore());
								sentenciaStore.setInt("Par_TipoMaquilador", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoMaquilador()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//BDPRINCIPAL
	public MensajeTransaccionBean tipoTarjetaDebitoBDPrincipal(final int tipoTransaccion, final TipoTarjetaDebBean tipoTarjetaDebBean) {

	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(

						new CallableStatementCreator() {

							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call TIPOTARJETADEBITOALT(?,?,?,?,?,    ?,?,?,?,?,    ?,?,?,?,?,	 ?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,	?,?,? ,?,?,?,?,?,?,?);";

								loggerSAFI.info(tipoTarjetaDebBean.getPatrocinadorID());
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_Descripcion",tipoTarjetaDebBean.getDescripcion());
								sentenciaStore.setString("Par_CompraPOS",tipoTarjetaDebBean.getCompraPOSLinea());
								sentenciaStore.setString("Par_Estatus",tipoTarjetaDebBean.getEstatus());
								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_IdentificaSocio",tipoTarjetaDebBean.getIdentificacionSocio());

								sentenciaStore.setString("Par_TipoProsaID", tipoTarjetaDebBean.getTipoProsaID());
								sentenciaStore.setInt("Par_VigenciaMeses", Utileria.convierteEntero(tipoTarjetaDebBean.getVigenciaMeses()));
								sentenciaStore.setString("Par_ColorTarjeta", tipoTarjetaDebBean.getColorTarjeta());
								sentenciaStore.setString("Par_TipoTarjeta", tipoTarjetaDebBean.getTipoTarjeta());
								sentenciaStore.setInt("Par_ProductoCredito", Utileria.convierteEntero(tipoTarjetaDebBean.getProductoCredito()));

								sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(tipoTarjetaDebBean.getTasaFija()));
								sentenciaStore.setDouble("Par_MontoAnual", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoAnual()));
								sentenciaStore.setString("Par_CobraMora", tipoTarjetaDebBean.getCobraMora());
								sentenciaStore.setString("Par_TipoMora", tipoTarjetaDebBean.getTipoMora());
								sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(tipoTarjetaDebBean.getFactorMora()));

								sentenciaStore.setString("Par_CobFalPago", tipoTarjetaDebBean.getCobFaltaPago());
								sentenciaStore.setString("Par_TipoFalPago", tipoTarjetaDebBean.getTipoFaltaPago());
								sentenciaStore.setDouble("Par_FacFalPago", Utileria.convierteDoble(tipoTarjetaDebBean.getFacFaltaPago()));
								sentenciaStore.setDouble("Par_PorcPagMin", Utileria.convierteDoble(tipoTarjetaDebBean.getPorcPagoMin()));
								sentenciaStore.setDouble("Par_MontoCredito", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoCredito()));

								sentenciaStore.setDouble("Par_FacComisionAper", Utileria.convierteDoble(tipoTarjetaDebBean.getFacComisionAper()));
								sentenciaStore.setString("Par_CobComisionAper", tipoTarjetaDebBean.getCobComisionAper());
								sentenciaStore.setString("Par_TipoCobComAper", tipoTarjetaDebBean.getTipoCobComAper());
								sentenciaStore.setInt("Par_TarBinParamsID", Utileria.convierteEntero(tipoTarjetaDebBean.getTarBinParamsID()));
								sentenciaStore.setString("Par_NumSubBIN", tipoTarjetaDebBean.getNumSubBIN());

								sentenciaStore.setString("Par_PatrocinadorID", tipoTarjetaDebBean.getPatrocinadorID());
								sentenciaStore.setInt("Par_TipoCore", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoCore()));
								sentenciaStore.setString("Par_UrlCore", tipoTarjetaDebBean.getUrlCore());
								sentenciaStore.setInt("Par_TipoMaquilador", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoMaquilador()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info("BDPrincipal"+"-"+sentenciaStore.toString());

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
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

//------------------------------------consulta de tipo de tarjeta debito  BDPrincipal ----------------------
	public TipoTarjetaDebBean consultaTipoTarjetaDebitoBDPrincipal(int tipoConsulta,TipoTarjetaDebBean tipoTarjetaDebBean){

		String query = "call TIPOTARJETADEBCON(?,?,?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tipoTarjetaDebBean.getTipoTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.STRING_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TIPOTARJETADEBCON.consultaTipoTarjetaDebitoBDPrin",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info("BDPrincipal"+"-"+"call TIPOTARJETADEBCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb= new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjetaDeb.setDescripcion(resultSet.getString(2));
				tipoTarjetaDeb.setCompraPOSLinea(resultSet.getString(3));
				tipoTarjetaDeb.setEstatus(resultSet.getString(4));
				tipoTarjetaDeb.setIdentificacionSocio(resultSet.getString(5));
				tipoTarjetaDeb.setTipoProsaID(resultSet.getString(6));
				tipoTarjetaDeb.setColorTarjeta(resultSet.getString(7));
				tipoTarjetaDeb.setVigenciaMeses(resultSet.getString(8));
				tipoTarjetaDeb.setTipoTarjeta(resultSet.getString(9));
				tipoTarjetaDeb.setTasaFija(resultSet.getString(10));
				tipoTarjetaDeb.setMontoAnual(resultSet.getString(11));
				tipoTarjetaDeb.setCobraMora(resultSet.getString(12));
				tipoTarjetaDeb.setTipoMora(resultSet.getString(13));
				tipoTarjetaDeb.setFactorMora(resultSet.getString(14));
				tipoTarjetaDeb.setCobFaltaPago(resultSet.getString(15));
				tipoTarjetaDeb.setTipoFaltaPago(resultSet.getString(16));
				tipoTarjetaDeb.setFacFaltaPago(resultSet.getString(17));
				tipoTarjetaDeb.setPorcPagoMin(resultSet.getString(18));
				tipoTarjetaDeb.setMontoCredito(resultSet.getString(19));
				tipoTarjetaDeb.setProductoCredito(resultSet.getString(20));
				tipoTarjetaDeb.setCobComisionAper(resultSet.getString("CobComisionAper"));
				tipoTarjetaDeb.setTipoCobComAper(resultSet.getString("TipoCobComAper"));
				tipoTarjetaDeb.setFacComisionAper(resultSet.getString("FacComisionAper"));
				tipoTarjetaDeb.setTarBinParamsID(resultSet.getString("TarBinParamsID"));
				tipoTarjetaDeb.setTipoCore(resultSet.getString("TipoCore"));
				tipoTarjetaDeb.setUrlCore(resultSet.getString("UrlCore"));
				tipoTarjetaDeb.setNumSubBIN(resultSet.getString("NumSubBIN"));
				tipoTarjetaDeb.setPatrocinadorID(resultSet.getString("PatrocinadorID"));
				tipoTarjetaDeb.setTipoMaquilador(resultSet.getString("TipoMaquilador"));
			return tipoTarjetaDeb;
			}
		});

		return matches.size() > 0 ? (TipoTarjetaDebBean) matches.get(0) : null;
	}
	//------------- Modificar tipo de tarjeta debito----------------------
	/* Modificacion de tipo de tarjeta debito */
	public MensajeTransaccionBean modtipoTarjetaDebito(final TipoTarjetaDebBean tipoTarjetaDebBean){
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

					String query = "call TIPOTARJETADEBITOMOD(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoTarjetaDebID",tipoTarjetaDebBean.getTipoTarjetaDebID());
								sentenciaStore.setString("Par_Descripcion",tipoTarjetaDebBean.getDescripcion());
								sentenciaStore.setString("Par_CompraPOS",tipoTarjetaDebBean.getCompraPOSLinea());
								sentenciaStore.setString("Par_Estatus",tipoTarjetaDebBean.getEstatus());
								sentenciaStore.setString("Par_IdentificaSocio",tipoTarjetaDebBean.getIdentificacionSocio());

								sentenciaStore.setString("Par_TipoProsaID", tipoTarjetaDebBean.getTipoProsaID());
								sentenciaStore.setInt("Par_VigenciaMeses", Utileria.convierteEntero(tipoTarjetaDebBean.getVigenciaMeses()));
								sentenciaStore.setString("Par_ColorTarjeta", tipoTarjetaDebBean.getColorTarjeta());
								sentenciaStore.setString("Par_TipoTarjeta", tipoTarjetaDebBean.getTipoTarjeta());
								sentenciaStore.setInt("Par_ProductoCredito", Utileria.convierteEntero(tipoTarjetaDebBean.getProductoCredito()));

								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(tipoTarjetaDebBean.getTasaFija()));
								sentenciaStore.setDouble("Par_MontoAnual", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoAnual()));
								sentenciaStore.setString("Par_CobraMora", tipoTarjetaDebBean.getCobraMora());
								sentenciaStore.setString("Par_TipoMora", tipoTarjetaDebBean.getTipoMora());
								sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(tipoTarjetaDebBean.getFactorMora()));

								sentenciaStore.setString("Par_CobFalPago", tipoTarjetaDebBean.getCobFaltaPago());
								sentenciaStore.setString("Par_TipoFalPago", tipoTarjetaDebBean.getTipoFaltaPago());
								sentenciaStore.setDouble("Par_FacFalPago", Utileria.convierteDoble(tipoTarjetaDebBean.getFacFaltaPago()));
								sentenciaStore.setDouble("Par_PorcPagMin", Utileria.convierteDoble(tipoTarjetaDebBean.getPorcPagoMin()));
								sentenciaStore.setDouble("Par_MontoCredito", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoCredito()));


								sentenciaStore.setDouble("Par_FacComisionAper", Utileria.convierteDoble(tipoTarjetaDebBean.getFacComisionAper()));
								sentenciaStore.setString("Par_CobComisionAper", tipoTarjetaDebBean.getCobComisionAper());
								sentenciaStore.setString("Par_TipoCobComAper", tipoTarjetaDebBean.getTipoCobComAper());
								sentenciaStore.setInt("Par_TarBinParamsID", Utileria.convierteEntero(tipoTarjetaDebBean.getTarBinParamsID()));
								sentenciaStore.setString("Par_NumSubBIN", tipoTarjetaDebBean.getNumSubBIN());

								sentenciaStore.setString("Par_PatrocinadorID", tipoTarjetaDebBean.getPatrocinadorID());
								sentenciaStore.setInt("Par_TipoCore", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoCore()));
								sentenciaStore.setString("Par_UrlCore", tipoTarjetaDebBean.getUrlCore());
								sentenciaStore.setInt("Par_TipoMaquilador", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoMaquilador()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plazas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de tipo de tarjeta debito BDPrincipal*/
	public MensajeTransaccionBean modtipoTarjetaDebitoBDPrincipal(final TipoTarjetaDebBean tipoTarjetaDebBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(

						new CallableStatementCreator() {

						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

					String query = "call TIPOTARJETADEBITOMOD(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,	?,?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoTarjetaDebID",tipoTarjetaDebBean.getTipoTarjetaDebID());
								sentenciaStore.setString("Par_Descripcion",tipoTarjetaDebBean.getDescripcion());
								sentenciaStore.setString("Par_CompraPOS",tipoTarjetaDebBean.getCompraPOSLinea());
								sentenciaStore.setString("Par_Estatus",tipoTarjetaDebBean.getEstatus());
								sentenciaStore.setString("Par_IdentificaSocio",tipoTarjetaDebBean.getIdentificacionSocio());

								sentenciaStore.setString("Par_TipoProsaID", tipoTarjetaDebBean.getTipoProsaID());
								sentenciaStore.setInt("Par_VigenciaMeses", Utileria.convierteEntero(tipoTarjetaDebBean.getVigenciaMeses()));
								sentenciaStore.setString("Par_ColorTarjeta", tipoTarjetaDebBean.getColorTarjeta());
								sentenciaStore.setString("Par_TipoTarjeta", tipoTarjetaDebBean.getTipoTarjeta());
								sentenciaStore.setInt("Par_ProductoCredito", Utileria.convierteEntero(tipoTarjetaDebBean.getProductoCredito()));

								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(tipoTarjetaDebBean.getTasaFija()));
								sentenciaStore.setDouble("Par_MontoAnual", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoAnual()));
								sentenciaStore.setString("Par_CobraMora", tipoTarjetaDebBean.getCobraMora());
								sentenciaStore.setString("Par_TipoMora", tipoTarjetaDebBean.getTipoMora());
								sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(tipoTarjetaDebBean.getFactorMora()));

								sentenciaStore.setString("Par_CobFalPago", tipoTarjetaDebBean.getCobFaltaPago());
								sentenciaStore.setString("Par_TipoFalPago", tipoTarjetaDebBean.getTipoFaltaPago());
								sentenciaStore.setDouble("Par_FacFalPago", Utileria.convierteDoble(tipoTarjetaDebBean.getFacFaltaPago()));
								sentenciaStore.setDouble("Par_PorcPagMin", Utileria.convierteDoble(tipoTarjetaDebBean.getPorcPagoMin()));
								sentenciaStore.setDouble("Par_MontoCredito", Utileria.convierteDoble(tipoTarjetaDebBean.getMontoCredito()));


								sentenciaStore.setDouble("Par_FacComisionAper", Utileria.convierteDoble(tipoTarjetaDebBean.getFacComisionAper()));
								sentenciaStore.setString("Par_CobComisionAper", tipoTarjetaDebBean.getCobComisionAper());
								sentenciaStore.setString("Par_TipoCobComAper", tipoTarjetaDebBean.getTipoCobComAper());
								sentenciaStore.setInt("Par_TarBinParamsID", Utileria.convierteEntero(tipoTarjetaDebBean.getTarBinParamsID()));
								sentenciaStore.setString("Par_NumSubBIN", tipoTarjetaDebBean.getNumSubBIN());

								sentenciaStore.setString("Par_PatrocinadorID", tipoTarjetaDebBean.getPatrocinadorID());
								sentenciaStore.setInt("Par_TipoCore", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoCore()));
								sentenciaStore.setString("Par_UrlCore", tipoTarjetaDebBean.getUrlCore());
								sentenciaStore.setInt("Par_TipoMaquilador", Utileria.convierteEntero(tipoTarjetaDebBean.getTipoMaquilador()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info("BDPrincipal"+"-"+sentenciaStore.toString());

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
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"error en modificacion de plazas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Combo que muestra los tipos de tarjetas para el cobro de anualidad */
	public List comboColorTarjetas(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
			String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = { Constantes.STRING_VACIO,
				                tipoTarjetaDebBean.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.comboColorTarjetas",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setColorTarjeta(resultSet.getString("ColorTarjeta"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));
				return tipoTarjetaDeb;
			}
		});
		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaPrincipal;
	}

	/* Combo que muestra los tipos de tarjetas para el cobro de anualidad - BDPrincipal*/
	public List comboTipoTarjetaCobroBDPrincipal(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
			String query = "call TIPOTARJETADEBLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = { Constantes.STRING_VACIO,
				                tipoTarjetaDebBean.getTipoTarjetaDebID(),
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.comboTipoTarjetaCobroBDPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info("BDPrincipal"+"-"+"call TIPOTARJETADEBLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
				tipoTarjetaDeb.setDescripcion(resultSet.getString("Descripcion"));
				return tipoTarjetaDeb;
			}
		});
		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("BDPrincipal"+"-"+"error en lista principal de tarjeta de debito", e);
		}
		return listaPrincipal;
	}

	/* Lista catalogo de servicios de tarjetas */
	public List comboServiceCode(TipoTarjetaDebBean tipoTarjetaDebBean, int tipoLista) {
		List listaPrincipal=null;
		try{
			String query = "call CATSERVICECODLIS(?,	?,?,?,?,?,?,?);";
		Object[] parametros = { 2,	//Lista Combo

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.comboServiceCode",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATSERVICECODLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean catServiceCode = new TipoTarjetaDebBean();
				catServiceCode.setCatServiceCodeID(resultSet.getString("CatServiceCodeID"));
				catServiceCode.setNumeroServicio(resultSet.getString("NumeroServicio"));
				catServiceCode.setDescripcion(resultSet.getString("Descripcion"));
				return catServiceCode;
			}
		});
		listaPrincipal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista combo de codigos de servicio en tarjetas", e);
		}
		return listaPrincipal;
	}

	/* Lista para mostrar los patrocinadores para los subBin -microfin*/

	public List comboPatrocinados(TipoTarjetaDebBean tipoTarjetaDebBean,int tipoLista){
		List matches=null;
		try{
			String query = "call CATALOGOPATROCLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {  tipoTarjetaDebBean.getPatrocinadorID(),
								Constantes.ENTERO_UNO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaDebDAO.comboPatrocinados",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOPATROCLIS(" + Arrays.toString(parametros) +")");
		matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();

				tipoTarjetaDeb.setPatrocinadorID(resultSet.getString("PatrocinadorID"));
				tipoTarjetaDeb.setNombrePatroc(resultSet.getString("NombrePatroc"));
				return tipoTarjetaDeb;
			}
		});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de patrocinadores para subBin", e);
		}
		return matches;
	}

	/* Lista que muestra los SubBin relacionados al Bin -microfin*/

	public List listaPatrocSubBin(TipoTarjetaDebBean tipoTarjetaDebBean,int tipoLista){
		List matches=null;
		try{
			String query = "call TIPOTARJETASUBBINLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					                tipoTarjetaDebBean.getNumBIN(),
					                Constantes.ENTERO_UNO,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TipoTarjetaDebDAO.listaPatrocSubBin",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOTARJETASUBBINLIS(" + Arrays.toString(parametros) +")");
		matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TipoTarjetaDebBean tipoTarjetaDeb = new TipoTarjetaDebBean();

				tipoTarjetaDeb.setNumSubBIN(resultSet.getString("NumSubBIN"));
				tipoTarjetaDeb.setNombrePatroc(resultSet.getString("NombrePatroc"));
				tipoTarjetaDeb.setEstatus(resultSet.getString("Estatus"));


				return tipoTarjetaDeb;
			}
		});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de patrocinadores para subBin", e);
		}
		return matches;
	}

	/*Eliminar  los SubBin relacionados al Bin -microfin*/
	public MensajeTransaccionBean BajtipoTarjetaSudBin(final TipoTarjetaDebBean tipoTarjetaDebBean){
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

					String query = "call TIPOTARJETASUBBINBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TarBinParamsID",Utileria.convierteEntero(tipoTarjetaDebBean.getNumBINs()));
								sentenciaStore.setInt("Par_NumSubBIN",Utileria.convierteEntero(tipoTarjetaDebBean.getNumSubBINs()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Modificacion de tipo de tarjeta debito BDPrincipal*/
	public MensajeTransaccionBean BajtipoTarjetaSudBinBDPrincipal(final TipoTarjetaDebBean tipoTarjetaDebBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(

						new CallableStatementCreator() {

						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call TIPOTARJETASUBBINBAJ(?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_TarBinParamsID",Utileria.convierteEntero(tipoTarjetaDebBean.getNumBINs()));
										sentenciaStore.setInt("Par_NumSubBIN",Utileria.convierteEntero(tipoTarjetaDebBean.getNumSubBINs()));

										sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
										// Parametros de OutPut
										sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("BDPrincipal"+"-"+"error en modificacion de plazas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
