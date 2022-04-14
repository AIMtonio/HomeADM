package credito.dao;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import credito.bean.AvaladosCreditoRepBean;

public class AvaldosCreditoRepDAO extends BaseDAO{

	public List<AvaladosCreditoRepBean> consultaAvalesCreditoExcel(
			AvaladosCreditoRepBean avaladosCreditoRepBean, int tipoLista) {
		// TODO Auto-generated method stub
		List listaResultadoAvales = null;
		
		try{
		String query = "call AVALESCREDITOREP(?,?,?,?,?  ,?,?,?,?,?   ,?,?,?,?,?, ?)";
		
		Object[] parametros ={
				Utileria.convierteEntero(avaladosCreditoRepBean.getClienteInicial()),
				Utileria.convierteEntero(avaladosCreditoRepBean.getClienteFinal()),
				Utileria.convierteFecha(avaladosCreditoRepBean.getFechaInicial()),
				Utileria.convierteFecha(avaladosCreditoRepBean.getFechaFinal()),
				Utileria.convierteEntero(avaladosCreditoRepBean.getPromotor()),
				Utileria.convierteEntero(avaladosCreditoRepBean.getDiasMora()),
				Utileria.convierteEntero(avaladosCreditoRepBean.getSucursalID()),
				avaladosCreditoRepBean.getEstatus(),
				Utileria.convierteEntero(avaladosCreditoRepBean.getProducCreditoID()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AvaldosCreditoRepDAO.consultaAvalesCreditoExcel",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AVALESCREDITOREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AvaladosCreditoRepBean avaladosCreditoRep= new AvaladosCreditoRepBean();
				
				avaladosCreditoRep.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				avaladosCreditoRep.setNombreCliente(resultSet.getString("NombreCliente"));
				avaladosCreditoRep.setCreditoID(resultSet.getString("CreditoID"));
				avaladosCreditoRep.setMontoCredito(String.valueOf(resultSet.getDouble("MontoCredito")));
				avaladosCreditoRep.setNombreProducto(resultSet.getString("Descripcion"));
				avaladosCreditoRep.setEstatus(resultSet.getString("Estatus"));
				avaladosCreditoRep.setSaldoActual(String.valueOf(resultSet.getDouble("SaldoActual")));
				avaladosCreditoRep.setSaldoExigible(String.valueOf(resultSet.getDouble("SaldoExigible")));
				avaladosCreditoRep.setAvalID(resultSet.getString("AvalID"));
				avaladosCreditoRep.setCliente(resultSet.getString("Cliente"));
				avaladosCreditoRep.setProspectoID(resultSet.getString("ProspectoID"));
				avaladosCreditoRep.setNombreAval(resultSet.getString("NombreCompleto"));
				avaladosCreditoRep.setDiasMora(String.valueOf(resultSet.getInt("DiaMora")));
				avaladosCreditoRep.setFechaExigible(String.valueOf(resultSet.getDate("FechaExigible")));
				return avaladosCreditoRep ;
			}
		});
		listaResultadoAvales= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de Avales Credito", e);
		}
		return listaResultadoAvales;
	}

}

