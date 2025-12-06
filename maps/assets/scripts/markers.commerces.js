async function MarkersCommerces(world) {
    const response = await fetch("api/get/commerces.php?data="+world);
    const res = await response.json();
    const datas = res.posts;
    let polygons = [];
    let markers = [];
    let popup, tooltip;
    console.log(datas);
    for (const one in datas){
        let data = datas[one];
        // Commerces
        for (let magasin in data.magasins) {
            let subdata = data.magasins[magasin];
            popup = '<a href="/rp/commerce/'+data.commerceid+'" class="button is-TD-smoothwhite" style="height: 30px;">'+data.name+'</a>';
            tooltip = '<b class="ultradarkblue">'+subdata.name+'</b>';
            markers.push({type: 'Markers', option: "civ", authorisation: data.authorisation, coords: "["+parseInt(-1*subdata.coord_z)+","+parseInt(subdata.coord_x)+"]", icon: ShopIcon, popup: popup, tooltip: tooltip});
        }
    }
    const json = {polygons: polygons, markers: markers};
    return json
}