# -*- coding: utf-8 -*-
# import asyncjackettclient
# import asyncio
# import torrent
# import aiohttp
#
# async def main():
#     cli = asyncjackettclient.JackettClient("http://192.168.1.107:9117/", "7oaltx51zlws47b9bp2s2lddll6ui9jq")
#     await cli.create_session()
#     ind = await cli.request_indexers()
#     print(ind)
#     ret = await cli.search_movie("The Dark Knight", 2008)
#     print(f"returned {len(ret)}")
#
#     torrs = await torrent.uri_to_magnets_uniq_torrents(ret)
#     print(f"{torrs}\n{len(torrs)}")
#     for torr in torrs:
#         print(torr['uri'])
#
# asyncio.run(main())
