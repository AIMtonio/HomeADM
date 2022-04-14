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
 
public class CreditosPorProductoDAO extends BaseDAO{
	public CreditosPorProductoDAO (){
		super();
	}
	// Lista para el Grid de Monto de Cartera por Producto
	public List listaMontoProducto(int tipoLista,UACIRiesgosBean riesgosBean) {
		//Query con el Store Procedure
		String query = "call CREDITOSPRODUCTOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorProductoDAO.listaCredProducto",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPRODUCTOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescProducto(resultSet.getString("NombreProducto"));
				riesgos.setMontoCartera(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Diferencia"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Lista para el Grid de Saldo de Cartera por Producto
	public List listaSaldoProducto(int tipoLista,UACIRiesgosBean riesgosBean) {
	//Query con el Store Procedure
		String query = "call CREDITOSPRODUCTOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorProductoDAO.listaParametro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPRODUCTOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescProducto(resultSet.getString("NombreProducto"));
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Diferencia"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para Reporte de Créditos por Producto en Excel
	public List reporteCreditoProducto(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDITOSPRODUCTOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPorProductoDAO.listaCredProducto",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPRODUCTOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescProducto(resultSet.getString("NombreProducto"));
				riesgos.setMontoCarteraProducto(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("ResultadoMonto"));
				riesgos.setParametroPorcentaje(resultSet.getString("PorcentajeMonto"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("DiferenciaMonto"));
				
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResPorcentualPro(resultSet.getString("ResultadoSaldo"));
				riesgos.setParamPorcentajePro(resultSet.getString("PorcentajeSaldo"));
				riesgos.setDifLimitePro(resultSet.getString("DiferenciaSaldo"));
				
				return riesgos;
			}
		});
		return matches;
	}

}
