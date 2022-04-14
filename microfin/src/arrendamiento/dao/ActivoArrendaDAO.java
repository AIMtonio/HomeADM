package arrendamiento.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.ActivoArrendaBean;

public class ActivoArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public ActivoArrendaDAO(){
		super();
	}

	/**
	 * Consulta principal de activos (C1)
	 * @param activoArrendaBean
	 * @param tipoConsulta
	 * @return
	 */
	public ActivoArrendaBean consultaPrincipalActivos(ActivoArrendaBean activoArrendaBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRACTIVOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				activoArrendaBean.getActivoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ActivoArrendaDAO.consultaPrincipalActivos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRACTIVOSCON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActivoArrendaBean activoBean = new ActivoArrendaBean();
				try{
					activoBean.setActivoID(resultSet.getString("ActivoID"));
					activoBean.setDescripcion(resultSet.getString("Descripcion"));
					activoBean.setTipoActivo(resultSet.getString("TipoActivo"));
					activoBean.setSubtipoActivoID(resultSet.getString("SubtipoActivoID"));
					activoBean.setSubtipoActivo(resultSet.getString("Subtipo"));
					activoBean.setModelo(resultSet.getString("Modelo"));
					activoBean.setMarcaID(resultSet.getString("MarcaID"));
					activoBean.setMarca(resultSet.getString("Marca"));
					activoBean.setNumeroSerie(resultSet.getString("NumeroSerie"));
					activoBean.setNumeroFactura(resultSet.getString("NumeroFactura"));
					activoBean.setValorFactura(resultSet.getString("ValorFactura"));
					activoBean.setCostosAdicionales(resultSet.getString("CostosAdicionales"));
					activoBean.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					activoBean.setVidaUtil(resultSet.getString("VidaUtil"));
					activoBean.setPorcentDepreFis(resultSet.getString("PorcentDepreFis"));
					activoBean.setPorcentDepreAjus(resultSet.getString("PorcentDepreAjus"));
					activoBean.setPlazoMaximo(resultSet.getString("PlazoMaximo"));
					activoBean.setPorcentResidMax(resultSet.getString("PorcentResidMax"));
					activoBean.setEstatus(resultSet.getString("Estatus"));

					// direccion
					activoBean.setEstadoID(resultSet.getString("EstadoID"));
					activoBean.setEstado(resultSet.getString("Estado"));
					activoBean.setMunicipioID(resultSet.getString("MunicipioID"));
					activoBean.setMunicipio(resultSet.getString("Municipio"));
					activoBean.setLocalidadID(resultSet.getString("LocalidadID"));
					activoBean.setLocalidad(resultSet.getString("NombreLocalidad"));
					activoBean.setColoniaID(resultSet.getString("ColoniaID"));
					activoBean.setColonia(resultSet.getString("Asentamiento"));
					activoBean.setCalle(resultSet.getString("Calle"));
					activoBean.setNumeroCasa(resultSet.getString("NumeroCasa"));
					activoBean.setNumeroInterior(resultSet.getString("NumeroInterior"));
					activoBean.setPiso(resultSet.getString("Piso"));
					activoBean.setPrimerEntrecalle(resultSet.getString("PrimerEntrecalle"));
					activoBean.setSegundaEntreCalle(resultSet.getString("SegundaEntreCalle"));
					activoBean.setCp(resultSet.getString("CP"));
					activoBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					activoBean.setLatitud(resultSet.getString("Latitud"));
					activoBean.setLongitud(resultSet.getString("Longitud"));
					activoBean.setLote(resultSet.getString("Lote"));
					activoBean.setManzana(resultSet.getString("Manzana"));
					activoBean.setDescripcionDom(resultSet.getString("DescripcionDom"));

					// aseguradora
					activoBean.setAseguradoraID(resultSet.getString("AseguradoraID"));
					activoBean.setAseguradora(resultSet.getString("Aseguradora"));
					activoBean.setEstaAsegurado(resultSet.getString("EstaAsegurado"));
					activoBean.setNumPolizaSeguro(resultSet.getString("NumPolizaSeguro"));
					activoBean.setFechaAdquiSeguro(resultSet.getString("FechaAdquiSeguro"));
					activoBean.setInicioCoberSeguro(resultSet.getString("InicioCoberSeguro"));
					activoBean.setFinCoberSeguro(resultSet.getString("FinCoberSeguro"));
					activoBean.setSumaAseguradora(resultSet.getString("SumaAseguradora"));
					activoBean.setValorDeduciSeguro(resultSet.getString("ValorDeduciSeguro"));
					activoBean.setObservaciones(resultSet.getString("Observaciones"));

				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return activoBean;
			}
		});
		return matches.size() > 0 ? (ActivoArrendaBean) matches.get(0) : null;
	}

	/**
	 * Consulta de activos con estatus A
	 * @param activoArrendaBean
	 * @param tipoConsulta
	 * @return
	 */
	public ActivoArrendaBean consultaActivosVinculacion(ActivoArrendaBean activoArrendaBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRACTIVOSCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				activoArrendaBean.getActivoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ActivoArrendaDAO.consultaActivosVinculacion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRACTIVOSCON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActivoArrendaBean activoBean = new ActivoArrendaBean();
				try{
					activoBean.setActivoID(resultSet.getString("ActivoID"));
					activoBean.setTipoActivo(resultSet.getString("TipoActivo"));
					activoBean.setDescripcion(resultSet.getString("Descripcion"));
					activoBean.setModelo(resultSet.getString("Modelo"));
					activoBean.setMarca(resultSet.getString("Marca"));
					activoBean.setNumeroSerie(resultSet.getString("NumeroSerie"));
					activoBean.setNumeroFactura(resultSet.getString("NumeroFactura"));
					activoBean.setValorFactura(resultSet.getString("ValorFactura"));
					activoBean.setCostosAdicionales(resultSet.getString("CostosAdicionales"));
					activoBean.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					activoBean.setSubtipoActivo(resultSet.getString("Subtipo"));
					activoBean.setPlazoMaximo(resultSet.getString("PlazoMaximo"));
					activoBean.setPorcentResidMax(resultSet.getString("PorcentResidMax"));
				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return activoBean;
			}
		});
		return matches.size() > 0 ? (ActivoArrendaBean) matches.get(0) : null;
	}

	/**
	 * Lista de Activos con estatus Activo, Inactivo y Ligado/Asociado(L1)
	 * @param activoArrendaBean
	 * @param tipoLista
	 * @return list
	 * @author vsanmiguel
	 */
	public List listaActivosInactivosLigados(ActivoArrendaBean activoArrendaBean, int tipoLista){
		List activos = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRACTIVOSLIS(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	activoArrendaBean.getActivoID(),
									activoArrendaBean.getTipoActivo(),
									tipoLista,


									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ActivoArrendaDAO.listaActivosEInactivos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRACTIVOSLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ActivoArrendaBean activoBean = new ActivoArrendaBean();
					activoBean.setActivoID(resultSet.getString("ActivoID"));
					activoBean.setDescripcion(resultSet.getString("Descripcion"));
					return activoBean;
				}
			});
			return activos = matches.size() > 0 ? matches: null;

		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de Activos.", e);
			e.printStackTrace();
		}
		return activos;
	}


	/**
	 * Metodo para dar de alta activos
	 * @param activoArrendaBean
	 * @return
	 */
	public MensajeTransaccionBean altaActivos(final ActivoArrendaBean activoArrendaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRACTIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
																	  "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
																	  "?,?,?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion", activoArrendaBean.getDescripcion());
									sentenciaStore.setInt("Par_TipoActivo", Utileria.convierteEntero(activoArrendaBean.getTipoActivo()));
									sentenciaStore.setInt("Par_SubtipoActivoID", Utileria.convierteEntero(activoArrendaBean.getSubtipoActivoID()));
									sentenciaStore.setString("Par_Modelo", activoArrendaBean.getModelo());
									sentenciaStore.setInt("Par_MarcaID", Utileria.convierteEntero(activoArrendaBean.getMarcaID()));
									sentenciaStore.setString("Par_NumeroSerie", activoArrendaBean.getNumeroSerie());
									sentenciaStore.setString("Par_NumeroFactura", activoArrendaBean.getNumeroFactura());
									sentenciaStore.setDouble("Par_ValorFactura", Utileria.convierteDoble(activoArrendaBean.getValorFactura()));
									sentenciaStore.setDouble("Par_CostosAdicionales", Utileria.convierteDoble(activoArrendaBean.getCostosAdicionales()));
									sentenciaStore.setDate("Par_FechaAdquisicion", OperacionesFechas.conversionStrDate(activoArrendaBean.getFechaAdquisicion()));
									sentenciaStore.setInt("Par_VidaUtil", Utileria.convierteEntero(activoArrendaBean.getVidaUtil()));
									sentenciaStore.setDouble("Par_PorcentDepreFis", Utileria.convierteDoble(activoArrendaBean.getPorcentDepreFis()));
									sentenciaStore.setDouble("Par_PorcentDepreAjus", Utileria.convierteDoble(activoArrendaBean.getPorcentDepreAjus()));
									sentenciaStore.setInt("Par_PlazoMaximo", Utileria.convierteEntero(activoArrendaBean.getPlazoMaximo()));
									sentenciaStore.setDouble("Par_PorcentResidMax", Utileria.convierteDoble(activoArrendaBean.getPorcentResidMax()));
									sentenciaStore.setString("Par_Estatus", activoArrendaBean.getEstatus());

									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(activoArrendaBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(activoArrendaBean.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(activoArrendaBean.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(activoArrendaBean.getColoniaID()));
									sentenciaStore.setString("Par_Calle", activoArrendaBean.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", activoArrendaBean.getNumeroCasa());
									sentenciaStore.setString("Par_NumeroInterior", activoArrendaBean.getNumeroInterior());
									sentenciaStore.setString("Par_Piso", activoArrendaBean.getPiso());
									sentenciaStore.setString("Par_PrimerEntrecalle", activoArrendaBean.getPrimerEntrecalle());
									sentenciaStore.setString("Par_SegundaEntreCalle", activoArrendaBean.getSegundaEntreCalle());
									sentenciaStore.setString("Par_CP", activoArrendaBean.getCp());
									sentenciaStore.setString("Par_Latitud", activoArrendaBean.getLatitud());
									sentenciaStore.setString("Par_Longitud", activoArrendaBean.getLongitud());
									sentenciaStore.setString("Par_Lote", activoArrendaBean.getLote());
									sentenciaStore.setString("Par_Manzana", activoArrendaBean.getManzana());
									sentenciaStore.setString("Par_DescripcionDom", activoArrendaBean.getDescripcionDom());

									sentenciaStore.setInt("Par_AseguradoraID", Utileria.convierteEntero(activoArrendaBean.getAseguradoraID()));
									sentenciaStore.setString("Par_EstaAsegurado", activoArrendaBean.getEstaAsegurado());
									sentenciaStore.setString("Par_NumPolizaSeguro", activoArrendaBean.getNumPolizaSeguro());
									sentenciaStore.setDate("Par_FechaAdquiSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getFechaAdquiSeguro()));
									sentenciaStore.setDate("Par_InicioCoberSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getInicioCoberSeguro()));
									sentenciaStore.setDate("Par_FinCoberSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getFinCoberSeguro()));
									sentenciaStore.setDouble("Par_SumaAseguradora", Utileria.convierteDoble(activoArrendaBean.getSumaAseguradora()));
									sentenciaStore.setDouble("Par_ValorDeduciSeguro", Utileria.convierteDoble(activoArrendaBean.getValorDeduciSeguro()));
									sentenciaStore.setString("Par_Observaciones", activoArrendaBean.getObservaciones());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_ConsecutivoAc", Types.INTEGER);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ActivArrendaDAO.altaActivos");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ActivArrendaDAO.altaActivos");
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
						throw new Exception(Constantes.MSG_ERROR + " ActivArrendaDAO.altaActivos");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al registra el Activo" + e);
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

	/**
	 * Metodo para modificar la informacion de los activos
	 * @param activoArrendaBean
	 * @return
	 */
	public MensajeTransaccionBean modificacionActivos(final ActivoArrendaBean activoArrendaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRACTIVOSMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
																	  "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
																	  "?,?,?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ActivoID", Utileria.convierteEntero(activoArrendaBean.getActivoID()));
									sentenciaStore.setString("Par_Descripcion", activoArrendaBean.getDescripcion());
									sentenciaStore.setInt("Par_TipoActivo", Utileria.convierteEntero(activoArrendaBean.getTipoActivo()));
									sentenciaStore.setInt("Par_SubtipoActivoID", Utileria.convierteEntero(activoArrendaBean.getSubtipoActivoID()));
									sentenciaStore.setString("Par_Modelo", activoArrendaBean.getModelo());
									sentenciaStore.setInt("Par_MarcaID", Utileria.convierteEntero(activoArrendaBean.getMarcaID()));
									sentenciaStore.setString("Par_NumeroSerie", activoArrendaBean.getNumeroSerie());
									sentenciaStore.setString("Par_NumeroFactura", activoArrendaBean.getNumeroFactura());
									sentenciaStore.setDouble("Par_ValorFactura", Utileria.convierteDoble(activoArrendaBean.getValorFactura()));
									sentenciaStore.setDouble("Par_CostosAdicionales", Utileria.convierteDoble(activoArrendaBean.getCostosAdicionales()));
									sentenciaStore.setDate("Par_FechaAdquisicion", OperacionesFechas.conversionStrDate(activoArrendaBean.getFechaAdquisicion()));
									sentenciaStore.setInt("Par_VidaUtil", Utileria.convierteEntero(activoArrendaBean.getVidaUtil()));
									sentenciaStore.setDouble("Par_PorcentDepreFis", Utileria.convierteDoble(activoArrendaBean.getPorcentDepreFis()));
									sentenciaStore.setDouble("Par_PorcentDepreAjus", Utileria.convierteDoble(activoArrendaBean.getPorcentDepreAjus()));
									sentenciaStore.setInt("Par_PlazoMaximo", Utileria.convierteEntero(activoArrendaBean.getPlazoMaximo()));
									sentenciaStore.setDouble("Par_PorcentResidMax", Utileria.convierteDoble(activoArrendaBean.getPorcentResidMax()));
									sentenciaStore.setString("Par_Estatus", activoArrendaBean.getEstatus());

									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(activoArrendaBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(activoArrendaBean.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(activoArrendaBean.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(activoArrendaBean.getColoniaID()));
									sentenciaStore.setString("Par_Calle", activoArrendaBean.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", activoArrendaBean.getNumeroCasa());
									sentenciaStore.setString("Par_NumeroInterior", activoArrendaBean.getNumeroInterior());
									sentenciaStore.setString("Par_Piso", activoArrendaBean.getPiso());
									sentenciaStore.setString("Par_PrimerEntrecalle", activoArrendaBean.getPrimerEntrecalle());
									sentenciaStore.setString("Par_SegundaEntreCalle", activoArrendaBean.getSegundaEntreCalle());
									sentenciaStore.setString("Par_CP", activoArrendaBean.getCp());
									sentenciaStore.setString("Par_Latitud", activoArrendaBean.getLatitud());
									sentenciaStore.setString("Par_Longitud", activoArrendaBean.getLongitud());
									sentenciaStore.setString("Par_Lote", activoArrendaBean.getLote());
									sentenciaStore.setString("Par_Manzana", activoArrendaBean.getManzana());
									sentenciaStore.setString("Par_DescripcionDom", activoArrendaBean.getDescripcionDom());

									sentenciaStore.setInt("Par_AseguradoraID", Utileria.convierteEntero(activoArrendaBean.getAseguradoraID()));
									sentenciaStore.setString("Par_EstaAsegurado", activoArrendaBean.getEstaAsegurado());
									sentenciaStore.setString("Par_NumPolizaSeguro", activoArrendaBean.getNumPolizaSeguro());
									sentenciaStore.setDate("Par_FechaAdquiSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getFechaAdquiSeguro()));
									sentenciaStore.setDate("Par_InicioCoberSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getInicioCoberSeguro()));
									sentenciaStore.setDate("Par_FinCoberSeguro", OperacionesFechas.conversionStrDate(activoArrendaBean.getFinCoberSeguro()));
									sentenciaStore.setDouble("Par_SumaAseguradora", Utileria.convierteDoble(activoArrendaBean.getSumaAseguradora()));
									sentenciaStore.setDouble("Par_ValorDeduciSeguro", Utileria.convierteDoble(activoArrendaBean.getValorDeduciSeguro()));
									sentenciaStore.setString("Par_Observaciones", activoArrendaBean.getObservaciones());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ActivArrendaDAO.agregarActivos");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ActivArrendaDAO.modificacionActivos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ActivArrendaDAO.modificacionActivos");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al modificar el Activo" + e);
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

	public MensajeTransaccionBean altaVinculacionActivos(final ActivoArrendaBean activoArrendaBean, final ArrayList listaDetalleGrid){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ActivoArrendaBean iterActivoArrendaBean = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = bajaActivosPorArrendamiento(activoArrendaBean, parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(!listaDetalleGrid.isEmpty()) {
						for(int i = 0; i < listaDetalleGrid.size(); i++){
							iterActivoArrendaBean = (ActivoArrendaBean) listaDetalleGrid.get(i);
							ActivoArrendaBean activoBean = new ActivoArrendaBean();
							activoBean.setArrendaID(iterActivoArrendaBean.getArrendaID());
							activoBean.setActivoID(iterActivoArrendaBean.getActivoID());
							mensajeBean = altaActivosPorArrendamiento(activoBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					if(mensajeBean.getNumero() == 0){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Lista de activos actualizada con éxito.");
						mensajeBean.setNombreControl("activoID");
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la vinculación de activos", e);
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	/**
	 * Metodo para dar de baja los activos ligados a un arrendamiento
	 * @param ActivoArrendaBean
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean bajaActivosPorArrendamiento(final ActivoArrendaBean activoArrendaBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final int bajaActivosPorArrendamiento = 1;
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRACTIVOARRENDAMIEBAJ(?,?,?,?,?, ?,?,?,?,?," +
																				"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(activoArrendaBean.getArrendaID()));
									sentenciaStore.setInt("Par_NumBaja", bajaActivosPorArrendamiento);

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ActivArrendaDAO.bajaActivosPorArrendamiento");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ActivoArrendaDAO.bajaActivosPorArrendamiento");
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
						throw new Exception(Constantes.MSG_ERROR + " ActivArrendaDAO.altaActivos");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error al eliminar los activos por arrendamiento" + e);
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

	/**
	 * Metodo para ligar activos a un arrendamiento
	 * @param ActivoArrendaBean
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaActivosPorArrendamiento(final ActivoArrendaBean activoArrendaBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRACTIVOARRENDAMIEALT(?,?,?,?,?, ?,?,?,?,?," +
																				"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendamientoID", Utileria.convierteLong(activoArrendaBean.getArrendaID()));
									sentenciaStore.setLong("Par_ActivoID", Utileria.convierteLong(activoArrendaBean.getActivoID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ActivArrendaDAO.altaActivosPorArrendamiento");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ActivoArrendaDAO.altaActivosPorArrendamiento");
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
						throw new Exception(Constantes.MSG_ERROR + " ActivArrendaDAO.altaActivos");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error al vincular los activos al arrendamiento" + e);
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

	/**
	 * Lista de Activos con estatus Activo
	 * @param activoArrendaBean
	 * @param tipoLista
	 * @return list
	 * @author aflores
	 */
	public List<?> listaActivosVinculacion(int tipoLista, ActivoArrendaBean activoArrendaBean) {
		List<?> listaActivos = null;
		try{
			String query = "call ARRACTIVOSLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					activoArrendaBean.getDescripcion(),
					activoArrendaBean.getTipoActivo(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ActivoArrendaDAO.listaActivosVinculacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRACTIVOSLIS(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ActivoArrendaBean resultado = new ActivoArrendaBean();
					resultado.setActivoID(resultSet.getString("ActivoID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));

					return resultado;
				}
			});
			listaActivos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de activos a vincular", e);
		}
		return listaActivos;
	}

	/**
	 * Lista de Activos por arrendamiento
	 * @param activoArrendaBean
	 * @param tipoLista
	 * @return list
	 * @author aflores
	 */
	public List<?> listaActivosArrendamiento(int tipoLista, ActivoArrendaBean activoArrendaBean) {
		List<?> listaActivos = null;
		try{
			String query = "call ARRACTIVOARRENDAMIELIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					activoArrendaBean.getArrendaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ActivoArrendaDAO.listaActivosArrendamiento",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRACTIVOARRENDAMIELIS(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ActivoArrendaBean resultado = new ActivoArrendaBean();
					resultado.setActivoID(resultSet.getString("ActivoID"));
					resultado.setTipoActivo(resultSet.getString("TipoActivo"));
					resultado.setDescripcion(resultSet.getString("ActivoDescripcion"));
					resultado.setSubtipoActivo(resultSet.getString("SubtipoDescripcion"));
					resultado.setMarca(resultSet.getString("MarcaDescripcion"));
					resultado.setModelo(resultSet.getString("Modelo"));
					resultado.setNumeroSerie(resultSet.getString("NumeroSerie"));
					resultado.setNumeroFactura(resultSet.getString("NumeroFactura"));
					resultado.setValorFactura(resultSet.getString("ValorFactura"));
					resultado.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					resultado.setPlazoMaximo(resultSet.getString("PlazoMaximo"));
					resultado.setPorcentResidMax(resultSet.getString("PorcentResidMax"));

					return resultado;
				}
			});
			listaActivos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de activos a vincular", e);
		}
		return listaActivos;
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
