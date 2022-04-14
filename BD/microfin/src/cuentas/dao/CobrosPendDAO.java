package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import bancaEnLinea.beanWS.request.ConsultaCargosPendientesBERequest;
import cuentas.bean.CobrosPendBean;
public class CobrosPendDAO extends BaseDAO  {
	
	public CobrosPendDAO() {
		super();
	}
	public List listaCobrosPendientesPorClienteCuenta(CobrosPendBean cobrosPendBean, int tipoLista){
		List listaCobrosPendientes = null; 
		try{
			String query = "call COBROSPENDLIS(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?,?);";
			Object[] parametros = {
					cobrosPendBean.getClienteID(),
					Utileria.convierteLong(cobrosPendBean.getCuentaAhoID()),
					cobrosPendBean.getMes(),
					cobrosPendBean.getAnio(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBROSPENDLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CobrosPendBean cobrosPendBean = new CobrosPendBean();
					cobrosPendBean.setFecha(resultSet.getString("Fecha"));
					cobrosPendBean.setDescripcion(resultSet.getString("Descripcion"));
					cobrosPendBean.setCantPenOri(resultSet.getString("CantPenOri"));
					cobrosPendBean.setCantPenAct(resultSet.getString("CantPenAct"));
					cobrosPendBean.setSumCanPenOri(resultSet.getString("Var_SumPenOri"));
					cobrosPendBean.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));
					return cobrosPendBean;
				}
			});
					
			listaCobrosPendientes	=	matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de cobros pendientes por cliente y cuenta "+ e);
		}
		
		return listaCobrosPendientes;
	}
	
	public List listaRepCobrosPendientes(CobrosPendBean cobrosPendBean, int tipoLista){
		List listaCobrosPendientes = null; 
		try{
			String query = "call CARGOSPENREP(" +
					"?,?,?,?, ?,?,?,?,?," +
					"?,?);";
			Object[] parametros = {
					cobrosPendBean.getFechaInicial(),
					cobrosPendBean.getFechaFinal(),
					Utileria.convierteEntero(cobrosPendBean.getClienteID()),
					Utileria.convierteLong(cobrosPendBean.getCuentaAhoID()),
				
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARGOSPENREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					CobrosPendBean cobrosPendBean = new CobrosPendBean();
					
					cobrosPendBean.setFecha(resultSet.getString("Fecha"));
					cobrosPendBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cobrosPendBean.setEtiquetaCuenta(resultSet.getString("Etiqueta"));
					cobrosPendBean.setDescripcion(resultSet.getString("Descripcion"));
					cobrosPendBean.setTransaccion(resultSet.getString("Transaccion"));
					cobrosPendBean.setFechaPago(resultSet.getString("FechaPago"));
					cobrosPendBean.setCantPenOri(resultSet.getString("CantPenOri"));
					cobrosPendBean.setCantPenAct(resultSet.getString("CantPenAct"));
					cobrosPendBean.setHoraEmision(resultSet.getString("HoraEmision"));
					
					return cobrosPendBean;
				}
			});
					
			listaCobrosPendientes	=	matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de cobros pendientes por cliente y cuenta "+ e);
		}
		
		
		return listaCobrosPendientes;
	}

	//----lista cobros pendientes banca en linea
	public List listaCobrosPendientesWS(ConsultaCargosPendientesBERequest consultaCargosPendientesBERequest, int tipoLista){
		List listaCobrosPendientes = null; 
		try{
			String query = "call COBROSPENDLIS(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(consultaCargosPendientesBERequest.getClienteID()),
					Utileria.convierteLong(consultaCargosPendientesBERequest.getCuentaAhoID()),
					Utileria.convierteEntero(consultaCargosPendientesBERequest.getMes()),
					Utileria.convierteEntero(consultaCargosPendientesBERequest.getAnio()),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBROSPENDLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CobrosPendBean cobrosPendBean = new CobrosPendBean();
					cobrosPendBean.setFecha(resultSet.getString("Fecha"));
					cobrosPendBean.setDescripcion(resultSet.getString("Descripcion"));
					cobrosPendBean.setCantPenOri(resultSet.getString("CantPenOri"));
					cobrosPendBean.setCantPenAct(resultSet.getString("CantPenAct"));
					cobrosPendBean.setSumCanPenOri(resultSet.getString("Var_SumPenOri"));
					cobrosPendBean.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));
					return cobrosPendBean;
				}
			});
					
			listaCobrosPendientes	=	matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de cobros pendientes por cliente y cuenta "+ e);
		}
		
		return listaCobrosPendientes;
	}
}
