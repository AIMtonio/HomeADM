package riesgos.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import riesgos.bean.UACIRiesgosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
public class CreditosPorSucursalDAO extends BaseDAO{
	public CreditosPorSucursalDAO (){
		super();
	}
	// Lista para el Grid de Monto de Cartera por Sucursal
	public List listaMontoSucursal(int tipoLista,UACIRiesgosBean riesgosBean) {
		//Query con el Store Procedure
		String query = "call CREDITOSSUCURSALREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorSucursalDAO.listaCredSucursal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSSUCURSALREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescSucursal(resultSet.getString("NombreSucursal"));
				riesgos.setMontoCartera(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteSuc(resultSet.getString("Diferencia"));
				
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Lista para el Grid de Saldo de Cartera por Sucursal
	public List listaSaldoSucursal(int tipoLista,UACIRiesgosBean riesgosBean) {
	//Query con el Store Procedure
		String query = "call CREDITOSSUCURSALREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorSucursalDAO.listaParametro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSSUCURSALREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescSucursal(resultSet.getString("NombreSucursal"));
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteSuc(resultSet.getString("Diferencia"));
				
				return riesgos;
			}
		});
		return matches;
	}

		
	// Consulta para Reporte de Créditos por Sucursales en Excel
	public List reporteCreditoSucursal(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDITOSSUCURSALREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorSucursalDAO.listaCredSucursal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSSUCURSALREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setSucursalID(resultSet.getString("SucursalID"));
				riesgos.setDescSucursal(resultSet.getString("NombreSucursal"));
				riesgos.setMontoCarteraSucursal(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("ResultadoMonto"));
				riesgos.setParametroPorcentaje(resultSet.getString("PorcentajeMonto"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("DiferenciaMonto"));
				
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResPorcentualSuc(resultSet.getString("ResultadoSaldo"));
				riesgos.setParamPorcentajeSuc(resultSet.getString("PorcentajeSaldo"));
				riesgos.setDifLimiteSuc(resultSet.getString("DiferenciaSaldo"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
}
